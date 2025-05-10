//
//  StorageKeys.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The StorageKeys class implements the WebViewEventHandler protocol
// to handle requests for retrieving all keys stored in the application's
// storage, triggered by web events. It interacts with the storage
// service to fetch the list of keys and communicates this information
// back to the web context.

class StorageKeys: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the StorageKeys handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "storage.keys" }

    // Handles the event to retrieve all keys stored in the application.
    // Invokes the storage service to fetch the keys and sends the
    // list back to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Retrieve all keys currently stored in the application's storage.
        let data = services.storage.keys()

        // Send a response back containing the retrieved list of keys.
        controller.sendResponse(r, e, data)
    }
}
