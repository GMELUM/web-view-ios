//
//  TapticSelection.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The TapticSelection class implements the WebViewEventHandler protocol
// to manage requests for generating taptic selection feedback on the device,
// triggered by web events. It allows the web context to initiate native
// selection haptic feedback to enhance user interactions.

class TapticSelection: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the TapticSelection handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "taptic.selection" }

    // Handles the event to produce a taptic selection feedback.
    // Interacts with the taptic engine service to initiate the feedback,
    // then communicates the result back to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Execute taptic selection feedback and capture the success status.
        let success = services.taptic.selection()
        
        // Send a response back indicating whether the taptic selection feedback was successful.
        controller.sendResponse(r, e, ["success": success])
    }
}
