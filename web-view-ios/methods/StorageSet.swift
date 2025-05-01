//
//  StorageSet.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {
    func storageSet(r: Int, e: String, d: Any) {

        guard let dataDictionary = d as? [String: Any],
            let key = dataDictionary["key"] as? String,
            let value = dataDictionary["value"] as? String
        else {
            sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }

        storageManager.set(forKey: key, value: value)
        sendResponse(requestID: r, event: e, data: ["success": true])

    }
}
