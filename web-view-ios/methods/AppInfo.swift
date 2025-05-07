//
//  AppInfo.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 05.05.2025.
//

import UIKit

extension App {

    // Gathers and sends basic application-related information.
    // - Parameters:
    //   - r: The request ID associated with this operation, used to correlate responses with requests.
    //   - e: The event name used to identify the type of request or action.
    //   - d: The data payload attached to the request (not used in this method).
    func appInfo(r: Int, e: String, d: Any) {

        // Send a response back to the requester with the app's language
        // and URL scheme information.
        webView.sendResponse(
            requestID: r,
            event: e,
            data: [
                // Retrieves the current language setting of the app.
                "language": getLanguage(),

                // Retrieves the URL scheme used by the app.
                "scheme": getScheme(),
            ]
        )
    }
}
