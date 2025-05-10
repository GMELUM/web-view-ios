//
//  LoaderService.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

import SwiftUI
import Combine

// The LoaderService class is an ObservableObject designed to manage
// the visibility state of a loading indicator within the application.
// It provides methods for showing and hiding the loader and uses
// published state to enable SwiftUI views to reactively update based
// on the loader's visibility.

final class LoaderService: ObservableObject {
    // A published property indicating whether the loader is currently visible.
    // Changes to this property will automatically update any SwiftUI views
    // that observe the LoaderService.
    @Published var isVisible: Bool = true

    // Shows the loader by setting its visibility to true.
    // - Returns: A boolean indicating the operation was successful.
    func show() -> Bool {
        isVisible = true
        return true
    }

    // Hides the loader by setting its visibility to false.
    // - Returns: A boolean indicating the operation was successful.
    func hide() -> Bool {
        isVisible = false
        return true
    }
}
