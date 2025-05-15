//
//  AppService.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

import Combine
import Foundation
import SwiftUI

// The AppService class is an ObservableObject designed to provide
// metadata information about the application. It gathers data
// such as the current language and user interface style, offering
// these details when requested by clients or other components.

final class AppService: ObservableObject {

    // Provides a dictionary containing current application metadata.
    // - Returns: A dictionary with keys "language" and "scheme" representing
    //   the current language code and UI appearance scheme, respectively.
    func info() -> [String: Any] {
        return [
            "language": getLanguage(),  // Fetch the current language setting
            "scheme": getScheme(),  // Determine the current user interface style
        ]
    }

    func getAppVersion() -> [String: Any] {
        // Получение словаря инфо-плист
        if let infoDictionary = Bundle.main.infoDictionary {
            // Извлечение версии приложения (CFBundleShortVersionString)
            let version =
                infoDictionary["CFBundleShortVersionString"] as? String
                ?? "Unknown"
            // Извлечение номера сборки приложения (CFBundleVersion)
            let build =
                infoDictionary["CFBundleVersion"] as? String ?? "Unknown"
            return [
                "version": version,
                "build": build,
            ]
        }
        return [
            "version": "0.0.0",
            "build": "0.0.0",
        ]
    }

    // Retrieves the current language setting of the app.
    // - Returns: A string representing the current language code.
    private func getLanguage() -> String {
        // Access the preferred language setting from the locale
        return Locale(identifier: Locale.preferredLanguages.first ?? "en")
            .languageCode ?? "en"
    }

    // Determines the current user interface style (light or dark).
    // - Returns: A string indicating the current appearance scheme.
    private func getScheme() -> String {
        // Check the device's current appearance mode
        let userInterfaceStyle = UIScreen.main.traitCollection
            .userInterfaceStyle
        let theme: String
        switch userInterfaceStyle {
        case .light:
            theme = "light"
        case .dark:
            theme = "dark"
        default:
            theme = "light"
        }
        return theme
    }

}
