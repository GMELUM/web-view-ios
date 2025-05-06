//
//  AppUpdate.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 04.05.2025.
//

import UIKit

extension App {
    func appUpdate(r: Int, e: String, d: Any) {

        // Отправляем ответ вызывающему коду
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
