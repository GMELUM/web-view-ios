//
//  StorageDelete.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 02.05.2025.
//

import UIKit

extension App {

    // Deletes a specified key from the storage.
    // - Parameters:
    //   - r: The request ID used to correlate the response with the original request.
    //   - e: The event name that triggered this action.
    //   - d: The data payload that contains the information about which key to delete.
    func storageDelete(r: Int, e: String, d: Any) {

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

        // Delete the specified key from the storage using the storage manager.
        storageManager.delete(forKey: key)

        // Send a success response back to indicate the key has been successfully deleted.
        webView.sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
