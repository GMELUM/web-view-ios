//
//  LoaderShow.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The LoaderShow class implements the WebViewEventHandler protocol
// to handle requests for displaying a loading indicator within the app.
// Triggered by web events, it communicates with the loader service
// to show the loader and informs the web context about the operation's outcome.

class LoaderShow: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the LoaderShow handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "loader.show" }

    // Handles the event to show the loader by interacting with
    // the loader service to perform the action, then reports the
    // success or failure back to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Attempt to show the loader via the service.
        let success = services.loader.show()
        
        // Send a response back to the requester indicating whether
        // showing the loader was successful.
        controller.sendResponse(r, e, ["success": success])
    }
}
