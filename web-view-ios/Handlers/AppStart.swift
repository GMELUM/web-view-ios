//
//  AppStart.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The AppStart class implements the WebViewEventHandler protocol
// to handle the initialization process when the app is triggered
// by a start event from JavaScript. It retrieves app information
// and performs necessary setup tasks upon startup.

class AppStart: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the AppStart handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "app.start" }

    // Handles the app start event, performing initialization tasks:
    // retrieves application information and updates the web context,
    // then hides the loader and informs the web of successful completion.
    func handle(r: Int, e: String, d: Any) {
        
        // Retrieve application information and convey it to the web context.
        let appInfo = services.app.info()
        controller.sendResponse(0, "app.update", appInfo)
        
        // Hide the loader as part of the app startup sequence.
        let success = services.loader.hide()
        
        // Send a response back to the requester, indicating if the operation was successful.
        controller.sendResponse(r, e, ["success": success])
    }
}
