//
//  AppStart.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

extension App {
    func appStart(r: Int, e: String, d: Any) {
        
        sendResponse(
            requestID: 0,
            event: "system.update",
            data: [
                "language": getLanguage(),
                "scheme": getScheme(),
            ]
        )

        loaderApp.hide()

        sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
