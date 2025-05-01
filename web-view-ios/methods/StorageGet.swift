//
//  StorageGet.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {
    func storageGet(r: Int, e: String, d: Any) {

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

        let value = storageManager.get(forKey: key) ?? ""
        sendResponse(requestID: r, event: e, data: [key: value])
        
    }
}
