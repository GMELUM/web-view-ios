//
//  StaticCacheService.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 11.05.2025.
//

import Foundation
import SwiftUI
import ZIPFoundation

final class StaticCacheService: ObservableObject {

    var onNewVersionDownloaded: (() -> Void)?

    @Published private(set) var launchURL: URL?

    @Published private(set) var isInstalledNewVersion: Bool = false

    private let lastLaunchedVersionKey = "lastLaunchedVersion"

    private let remoteVersionURL: URL
    private let cacheKey = "cachedAppVersion"
    private let folderName = "CachedWebApp"

    private let checkInterval: TimeInterval = 600  // 10 minute

    private var timer: Timer?

    init() {
        guard
            let versionURLString = Bundle.main.object(
                forInfoDictionaryKey: "WebViewVersionURL"
            ) as? String,
            let remoteVersionURL = URL(string: versionURLString)
        else {
            fatalError("Missing or invalid WebViewVersionURL in Info.plist")
        }

        self.remoteVersionURL = remoteVersionURL

        detectIfNewVersionInstalled()

        self.timer = Timer.scheduledTimer(
            withTimeInterval: checkInterval,
            repeats: true
        ) { [weak self] _ in
            self?.checkAndUpdateCacheSilently()
        }
    }

    private struct RemoteVersion: Decodable {
        let version: String
        let archive: String
    }

    var localIndexURL: URL? {
        let folder = getAppFolderURL()
        let indexPath = folder.appendingPathComponent("index.html")
        return FileManager.default.fileExists(atPath: indexPath.path)
            ? indexPath : nil
    }

    private func detectIfNewVersionInstalled() {
        let cachedVersion = UserDefaults.standard.string(forKey: cacheKey)
        let lastLaunchedVersion = UserDefaults.standard.string(
            forKey: lastLaunchedVersionKey
        )

        if let cachedVersion, cachedVersion != lastLaunchedVersion {
            isInstalledNewVersion = true
        } else {
            isInstalledNewVersion = false
        }

        if let cachedVersion {
            UserDefaults.standard.set(
                cachedVersion,
                forKey: lastLaunchedVersionKey
            )
        }
    }

    private func checkAndUpdateCacheSilently() {
        fetchRemoteVersion { [weak self] remote in
            guard let self = self, let remote else { return }

            let cachedVersion = UserDefaults.standard.string(
                forKey: self.cacheKey
            )

            guard cachedVersion != remote.version,
                let archiveURL = URL(string: remote.archive)
            else {
                return
            }

            self.downloadAndUnzip(from: archiveURL) { success in
                if success {
                    UserDefaults.standard.set(
                        remote.version,
                        forKey: self.cacheKey
                    )

                    DispatchQueue.main.async {
                        self.onNewVersionDownloaded?()
                    }
                }
            }
        }
    }

    func checkAndUpdateCache() {
        fetchRemoteVersion { [weak self] remote in
            guard let self = self, let remote else {
                DispatchQueue.main.async {
                    self?.launchURL = self?.localIndexURL
                }
                return
            }

            let cachedVersion = UserDefaults.standard.string(
                forKey: self.cacheKey
            )

            if cachedVersion == remote.version {
                DispatchQueue.main.async {
                    self.launchURL = self.localIndexURL
                }
            } else {
                guard let archiveURL = URL(string: remote.archive) else {
                    DispatchQueue.main.async {
                        self.launchURL = self.localIndexURL
                    }
                    return
                }

                self.downloadAndUnzip(from: archiveURL) { success in
                    if success {
                        UserDefaults.standard.set(
                            remote.version,
                            forKey: self.cacheKey
                        )
                        UserDefaults.standard.set(
                            remote.version,
                            forKey: self.lastLaunchedVersionKey
                        )
                    }
                    DispatchQueue.main.async {
                        self.launchURL = self.localIndexURL
                    }
                }
            }
        }
    }

    private func fetchRemoteVersion(
        completion: @escaping (RemoteVersion?) -> Void
    ) {
        URLSession.shared.dataTask(with: remoteVersionURL) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            if let version = try? decoder.decode(RemoteVersion.self, from: data)
            {
                completion(version)
            } else {
                completion(nil)
            }
        }.resume()
    }

    private func downloadAndUnzip(
        from url: URL,
        completion: @escaping (Bool) -> Void
    ) {
        URLSession.shared.downloadTask(with: url) { tempURL, _, _ in
            guard let tempURL else {
                completion(false)
                return
            }

            let folderURL = self.getAppFolderURL()

            try? FileManager.default.removeItem(at: folderURL)

            do {
                try FileManager.default.createDirectory(
                    at: folderURL,
                    withIntermediateDirectories: true
                )
                try FileManager.default.unzipItem(at: tempURL, to: folderURL)
                completion(true)
            } catch {
                completion(false)
            }
        }.resume()
    }

    private func getAppFolderURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[
            0
        ].appendingPathComponent(folderName)
    }
}
