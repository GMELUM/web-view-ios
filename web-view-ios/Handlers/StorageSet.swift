//
//  StorageSet.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The StorageSet class implements the WebViewEventHandler protocol
// to handle requests for adding or updating key-value pairs in the
// application's storage, triggered by web events. It ensures robust
// interaction between web content and native storage by validating
// incoming data and performing storage operations accordingly.

class StorageSet: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the StorageSet handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "storage.set" }

    // Handles the event to set a value for a specified key in storage.
    // Interprets the provided data, validates the format, and performs
    // the storage operation, then communicates the outcome to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Attempt to extract the key and value from the provided data payload.
        guard let dataDictionary = d as? [String: Any],
              let key = dataDictionary["key"] as? String,
              let value = dataDictionary["value"] as? String
        else {
            // Send an error response if the data format is invalid or missing required fields.
            return controller.sendError(
                r,
                e,
                "INVALID_DATA",
                "Invalid data format or target."
            )
        }

        // Store the value associated with the specified key in the storage.
        services.storage.set(forKey: key, value: value)

        // Send a response back indicating that the storage operation was successful.
        controller.sendResponse(r, e, ["success": true])
    }
}
