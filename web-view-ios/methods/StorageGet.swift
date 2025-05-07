//
//  StorageGet.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {

    // Retrieves a value from the storage for a specified key.
    // - Parameters:
    //   - r: The request ID used to correlate the response with the original request.
    //   - e: The event name that triggered this action.
    //   - d: The data payload that should contain the key for which the value is to be retrieved.
    func storageGet(r: Int, e: String, d: Any) {

        // Attempt to extract the key from the provided data payload.
        guard let dataDictionary = d as? [String: Any],
            let key = dataDictionary["key"] as? String
        else {
            // Send an error response if the data format is invalid or the required key is missing.
            webView.sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }

        // Retrieve the value associated with the specified key from the storage.
        // If the key does not exist, return an empty string.
        let value = storageManager.get(forKey: key) ?? ""

        // Send a response back containing the retrieved value.
        webView.sendResponse(requestID: r, event: e, data: [key: value])
    }
}
