//
//  AppObserver.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 05.05.2025.
//

import UIKit
import WebKit

class AppObserver {

    private weak var app: App!

    init(_ app: App) {

        self.app = app

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localeDidChange),
            name: NSLocale.currentLocaleDidChangeNotification,
            object: nil
        )

    }

    @objc func appDidEnterBackground() {
        app.sendResponse(requestID: 0, event: "app.background", data: [:])
    }

    @objc func appWillEnterForeground() {
        app.sendResponse(requestID: 0, event: "app.foreground", data: [:])
    }

    @objc func appDidBecomeActive() {
        app.sendResponse(requestID: 0, event: "app.active", data: [:])
    }

    @objc func appWillResignActive() {
        app.sendResponse(requestID: 0, event: "app.inactive", data: [:])
    }

    @objc func localeDidChange() {
        app.appUpdate(r: 0, e: "app.info", d: [:])
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
