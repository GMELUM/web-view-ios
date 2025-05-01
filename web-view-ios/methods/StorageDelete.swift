//
//  StorageDelete.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 02.05.2025.
//

import UIKit

extension App {
    func storageDelete(r: Int, e: String, d: Any) {

        guard let dataDictionary = d as? [String: Any],
              let key = dataDictionary["key"] as? String
        else {
            sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }
        
        storageManager.delete(forKey: key)
        sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
