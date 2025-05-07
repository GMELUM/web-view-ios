//
//  StorageKeys.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 02.05.2025.
//

import UIKit

extension App {

    // Retrieves a list of all keys currently stored in the storage system.
    // - Parameters:
    //   - r: The request ID used to correlate the response with the original request.
    //   - e: The event name that triggered this action.
    //   - d: The data payload associated with the request (not used in this method).
    func storageKeys(r: Int, e: String, d: Any) {

        // Retrieve all keys stored by the storage manager.
        let keys = storageManager.keys()

        // Send a response back containing the list of keys.
        webView.sendResponse(requestID: r, event: e, data: ["keys": keys])
    }
}
