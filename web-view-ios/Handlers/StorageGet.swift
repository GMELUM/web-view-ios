//
//  StorageGet.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The StorageGet class implements the WebViewEventHandler protocol
// to manage requests for retrieving a value from the application's storage,
// triggered by web events. It retrieves the requested data and communicates
// the result back to the web context, allowing for interaction between
// native storage and web content.

class StorageGet: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the StorageGet handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "storage.get" }

    // Handles the event to retrieve a value associated with a specified key from storage.
    // Interprets the provided data to extract the key and retrieves the data,
    // then communicates the result to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Attempt to extract the key from the provided data payload.
        guard let dataDictionary = d as? [String: Any],
              let key = dataDictionary["key"] as? String
        else {
            // Send an error response if the data format is invalid or the required key is missing.
            return controller.sendError(
                r,
                e,
                "INVALID_DATA",
                "Invalid data format or target."
            )
        }

        // Retrieve the value associated with the specified key from the storage.
        // If the key does not exist, return an empty string.
        let value = services.storage.get(forKey: key) ?? ""

        // Send a response back containing the retrieved value.
        controller.sendResponse(r, e, [key: value])
    }
}
