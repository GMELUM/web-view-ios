//
//  AppStart.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

extension App {

    // Handles actions required during the app start phase.
    // - Parameters:
    //   - r: The request ID associated with this app start operation.
    //   - e: The event name that triggers this app start action.
    //   - d: The payload data associated with the request (not directly used in this method).
    func appStart(r: Int, e: String, d: Any) {

        // Sends a system update event to provide the current language
        // and scheme to the requester. This could be used for initial
        // setup or configuration purposes on app start.
        webView.sendResponse(
            requestID: 0,  // Using 0 for generic or system-level requests.
            event: "system.update",  // Specifies the type of event or update being performed.
            data: [
                // Fetches the current language setting of the app.
                "language": getLanguage(),

                // Fetches the URL scheme the app is using.
                "scheme": getScheme(),
            ]
        )

        // Hides the loader view to transition from the loading state
        // to the main UI of the application. This provides a better
        // user experience by indicating the app is ready for interaction.
        loaderApp.hide()

        // Sends a response to indicate the app start process has completed successfully.
        webView.sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
