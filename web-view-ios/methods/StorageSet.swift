//
//  StorageSet.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {

    // Stores a key-value pair in the storage system.
    // - Parameters:
    //   - r: The request ID used to correlate the response with the original request.
    //   - e: The event name that triggered this action.
    //   - d: The data payload that contains the key and its associated value to store.
    func storageSet(r: Int, e: String, d: Any) {

        // Attempt to extract the key and value from the provided data payload.
        guard let dataDictionary = d as? [String: Any],
            let key = dataDictionary["key"] as? String,
            let value = dataDictionary["value"] as? String
        else {
            // Send an error response if the data format is invalid or missing required fields.
            webView.sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }

        // Store the key-value pair in the storage using the storage manager.
        storageManager.set(forKey: key, value: value)

        // Send a success response back to indicate the key-value pair was stored successfully.
        webView.sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
