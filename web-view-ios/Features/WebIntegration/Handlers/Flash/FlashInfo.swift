//
//  FlashInfo.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The FlashInfo class implements the WebViewEventHandler protocol
// to handle requests for device flash information triggered by
// web events. It queries the current state and settings of the device's
// flash (torch), then relays this information back to the web context.

class FlashInfo: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the FlashInfo handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "flash.info" }

    // Handles the flash info event, retrieving details about the device's flash.
    // These details are then transmitted back to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Query the current state and configuration of the device's flash.
        let data = services.flash.info()
        
        // Send the flash information back to the requester via the controller.
        controller.sendResponse(r, e, data)
    }
}
