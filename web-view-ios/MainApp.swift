//
//  MainApp.swift
//  webview-app
//
//  Created by Артур Гетьман on 08.05.2025.
//

import SwiftUI

// The webview_appApp struct serves as the entry point for the SwiftUI application,
// configuring the main scene and setting up the initial view hierarchy.

@main
struct web_view_iosApp: App {

    @StateObject private var services = Services()

    init() {
        // Register the custom URL protocol
        URLProtocol.registerClass(CustomURLProtocol.self)
    }

    // The body property of the App protocol contains the scene(s) that
    // determine the layout and behavior of the application at runtime.
    var body: some Scene {
        WindowGroup {
            // The WindowGroup here defines a group of windows that display
            // the app's main interface, employing the Main view as its content.
            Main()
                .environmentObject(services)
        }
    }
}
