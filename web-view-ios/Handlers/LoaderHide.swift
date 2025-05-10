//
//  LoaderHide.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The LoaderHide class implements the WebViewEventHandler protocol
// to manage requests for hiding a loading indicator within the app.
// Triggered by web events, it communicates with the loader service
// to hide the loader and informs the web context of the operation's outcome.

class LoaderHide: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the LoaderHide handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "loader.hide" }

    // Handles the event to hide the loader by interacting with
    // the loader service to perform the action, then reports the
    // success or failure back to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Attempt to hide the loader via the service.
        let success = services.loader.hide()
        
        // Send a response back to the requester indicating whether
        // hiding the loader was successful.
        controller.sendResponse(r, e, ["success": success])
    }
}
