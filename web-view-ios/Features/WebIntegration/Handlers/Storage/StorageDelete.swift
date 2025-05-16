//
//  StorageDelete.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The StorageDelete class implements the WebViewEventHandler protocol
// to manage requests for deleting an entry in the application's storage,
// triggered by web events. It facilitates the deletion process and
// communicates the success of the operation back to the web context.

class StorageDelete: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the StorageDelete handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "storage.delete" }

    // Handles the event to delete a specified key from storage.
    // Interprets the provided data to extract the key and performs
    // the deletion action, then communicates the result to the web context.
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

        // Perform the deletion operation for the specified key in storage.
        services.storage.delete(forKey: key)

        // Send a response back confirming the success of the operation.
        controller.sendResponse(r, e, ["success": true])
    }
}
