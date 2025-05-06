//
//  system.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 04.05.2025.
//

import UIKit
import Foundation

func getLanguage() -> String {
    return Locale(identifier: Locale.preferredLanguages.first ?? "en").languageCode ?? "en"
}

func getScheme() -> String {
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
