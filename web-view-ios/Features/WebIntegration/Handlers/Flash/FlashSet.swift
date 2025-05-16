//
//  FlashSet.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The FlashSet class implements the WebViewEventHandler protocol
// to manage requests for setting the device's flash intensity,
// as triggered via web events. It parses the desired level of intensity
// from the message and attempts to adjust the flash accordingly.

class FlashSet: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the FlashSet handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "flash.set" }

    // Handles the flash set event, interpreting the message to
    // adjust the flash's intensity to the specified level, if valid.
    func handle(r: Int, e: String, d: Any) {
        
        // Ensure the incoming data contains a valid level value between 0 and 100.
        guard let dataDictionary = d as? [String: Any],
              let level = dataDictionary["level"] as? Float,
              level >= 0 && level <= 100
        else {
            // Send an error if the data format is invalid or doesn't include the required information.
            return controller.sendError(
                r,
                e,
                "INVALID_DATA",
                "Invalid data format or target."
            )
        }

        // Attempt to set the flash intensity to the specified level.
        let success = services.flash.set(level)
        
        // Send a response back to the requester indicating whether the operation was successful.
        controller.sendResponse(r, e, ["success": success])
    }
}
