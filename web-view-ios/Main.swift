//
//  Main.swift
//  webview-app
//
//  Created by Артур Гетьман on 08.05.2025.
//

import SwiftUI
import WebKit

// The Main struct defines the main SwiftUI view for the application,
// providing an integration between web content and native loader,
// and handling app lifecycle and locale changes for reactive updates.

struct Main: View {

    // Observes the current color scheme to react to theme changes.
    @Environment(\.colorScheme) var colorScheme

    // StateObject instances to manage the WebViewController and app services.
    @StateObject private var wc = WebViewController()

    @EnvironmentObject private var services: Services

    // Publishers for observing app lifecycle and locale change notifications.
    private let didEnterBackground = NotificationCenter.default.publisher(
        for: UIApplication.didEnterBackgroundNotification
    )
    private let willEnterForeground = NotificationCenter.default.publisher(
        for: UIApplication.willEnterForegroundNotification
    )
    private let didBecomeActive = NotificationCenter.default.publisher(
        for: UIApplication.didBecomeActiveNotification
    )
    private let willResignActive = NotificationCenter.default.publisher(
        for: UIApplication.willResignActiveNotification
    )
    private let localeDidChange = NotificationCenter.default.publisher(
        for: NSLocale.currentLocaleDidChangeNotification
    )

    var body: some View {
        ZStack {
            // Integrates WebView to display web content within the app's main view.
            if let url = services.staticCache.launchURL {
                WebView(
                    url: url,
                    controller: wc,
                    services: services
                )
            }

            // Displays a loading indicator managed by the services.
            Loader(isVisible: $services.loader.isVisible)

            NotificationContainer()

        }
        .sheet(item: $services.modal.currentModal) { modal in
            modal.view
        }
        .edgesIgnoringSafeArea(.all)  // Extends view beyond safe area boundaries
        .onAppear {
            services.staticCache.onNewVersionDownloaded = {
                self.services.popup.add(
                    title: "notification.background.update.title",
                    message: "notification.background.update.message"
                )
            }
            services.staticCache.checkAndUpdateCache()
        }
        .onReceive(didEnterBackground) { _ in
            wc.sendResponse(0, "app.background", [:])  // React to app entering background
        }
        .onReceive(willEnterForeground) { _ in
            wc.sendResponse(0, "app.foreground", [:])  // React to app entering foreground
        }
        .onReceive(didBecomeActive) { _ in
            wc.sendResponse(0, "app.active", [:])  // React to app becoming active
        }
        .onReceive(willResignActive) { _ in
            wc.sendResponse(0, "app.inactive", [:])  // React to app resigning activity
        }
        .onReceive(localeDidChange) { _ in
            // Updates app information in response to locale changes.
            let appInfo = services.app.info()
            wc.sendResponse(0, "app.update", appInfo)
        }
        .onChange(of: colorScheme) { newColorScheme in
            // Sends updated app info to reflect theme changes.
            let appInfo = services.app.info()
            wc.sendResponse(0, "app.update", appInfo)
        }

    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
