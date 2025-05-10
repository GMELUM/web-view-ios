//
//  TapticNotification.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The TapticNotification class implements the WebViewEventHandler protocol
// to handle requests for generating taptic notifications on the device,
// triggered by web events. It allows the web context to initiate native
// haptic feedback through specified notification styles.

class TapticNotification: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the TapticNotification handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "taptic.notification" }

    // Handles the event to produce a taptic notification feedback.
    // Interprets the provided notification type and interacts with the
    // taptic engine service to produce the desired feedback,
    // then communicates the outcome to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Attempt to extract the notification type from the provided data payload.
        guard let dataDict = d as? [String: String],
              let styleString = dataDict["type"]
        else {
            // Send an error response if the data format is invalid or missing required fields.
            return controller.sendError(
                r,
                e,
                "INVALID_DATA",
                "Invalid data format or target."
            )
        }

        // Execute taptic notification with the specified type and report the success.
        let success = services.taptic.notification(styleString)
        
        // Send a response back indicating whether the taptic notification was successful.
        controller.sendResponse(r, e, ["success": success])
    }
}
