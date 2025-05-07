//
//  AppUpdate.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 04.05.2025.
//

import UIKit

extension App {

    // Handles the update logic for the app, sending relevant information back to the requester.
    // - Parameters:
    //   - r: The request ID, used to identify and correlate responses with requests.
    //   - e: The event name indicating the type or context of the update requested.
    //   - d: The data payload associated with the request (not used in this method).
    func appUpdate(r: Int, e: String, d: Any) {

        // Sends a response to the requester with the current application settings.
        // This includes key details such as the app's current language and URL scheme,
        // allowing the receiver to adjust its behavior or display accordingly.
        webView.sendResponse(
            requestID: r,
            event: e,
            data: [
                // Retrieves and provides the current language setting of the app.
                "language": getLanguage(),

                // Retrieves and provides the theme used by the app.
                "scheme": getScheme(),
            ]
        )
    }
}
