//
//  StorageKeys.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 02.05.2025.
//

import UIKit

extension App {
    func storageKeys(r: Int, e: String, d: Any) {
        
        let keys = storageManager.keys()
        sendResponse(requestID: r, event: e, data: ["keys": keys])
        
    }
}
