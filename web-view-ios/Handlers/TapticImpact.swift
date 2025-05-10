//
//  TapticImpact.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The TapticImpact class implements the WebViewEventHandler protocol
// to handle requests for generating haptic feedback (taptic impacts)
// on the device, triggered by web events. It ensures that the web
// context can trigger native haptic interactions by processing
// provided style definitions and executing them accordingly.

class TapticImpact: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the TapticImpact handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "taptic.impact" }

    // Handles the event to produce a taptic impact feedback.
    // Interprets the provided style data and interacts with the
    // taptic engine service to produce the desired feedback,
    // then communicates the outcome to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Attempt to extract the style information from the provided data payload.
        guard let dataDict = d as? [String: String],
              let styleString = dataDict["style"]
        else {
            // Send an error response if the data format is invalid or missing required fields.
            return controller.sendError(
                r,
                e,
                "INVALID_DATA",
                "Invalid data format or target."
            )
        }

        // Execute taptic impact with the specified style and report the success.
        let success = services.taptic.impact(styleString)
        
        // Send a response back indicating whether the taptic impact was successful.
        controller.sendResponse(r, e, ["success": success])
    }
}
