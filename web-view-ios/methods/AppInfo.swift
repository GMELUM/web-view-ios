//
//  AppInfo.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 05.05.2025.
//

import UIKit

extension App {
    func appInfo(r: Int, e: String, d: Any) {

        sendResponse(
            requestID: r,
            event: e,
            data: [
                "language": getLanguage(),
                "scheme": getScheme(),
            ]
        )

    }
}
