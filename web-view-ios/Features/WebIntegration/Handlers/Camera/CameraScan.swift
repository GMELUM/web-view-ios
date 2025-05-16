//
//  CameraScan.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

class CameraScan: WebViewEventHandler {
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
    static var action: String { "camera.scan" }

    // Handles the flash info event, retrieving details about the device's flash.
    // These details are then transmitted back to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Query the current state and configuration of the device's flash.
        services.modal.open(CameraScanModal()) { result in
            if let scanned = result as? String {
                print("Scanned result: \(scanned)")
                self.controller.sendResponse(r, e, ["text": scanned])
            } else {
                self.controller.sendResponse(r, e, ["text": ""])
            }
        }

    }
}
