//
//  PopupNotification.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 14.05.2025.
//

//
//  StorageGet.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The StorageGet class implements the WebViewEventHandler protocol
// to manage requests for retrieving a value from the application's storage,
// triggered by web events. It retrieves the requested data and communicates
// the result back to the web context, allowing for interaction between
// native storage and web content.

class PopupNotification: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the StorageGet handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "popup.notification" }

    // Handles the event to retrieve a value associated with a specified key from storage.
    // Interprets the provided data to extract the key and retrieves the data,
    // then communicates the result to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Attempt to extract the key from the provided data payload.
        guard let dataDictionary = d as? [String: Any],
            let title = dataDictionary["title"] as? String,
            let message = dataDictionary["message"] as? String,
            let duration = dataDictionary["duration"] as? Double,
            let positionString = dataDictionary["position"] as? String,
            let position = NotificationPosition(rawValue: positionString.lowercased())
        else {
            // Send an error response if the data format is invalid or the required key is missing.
            return controller.sendError(
                r,
                e,
                "INVALID_DATA",
                "Invalid data format or target."
            )
        }
        
        let icon = dataDictionary["icon"] as? String

        self.services.popup.add(
            icon: icon,
            title: title,
            message: message,
            position: position,
            duration: duration
        )

        // Send a response back containing the retrieved value.
        controller.sendResponse(r, e, ["success": true])
    }
}
