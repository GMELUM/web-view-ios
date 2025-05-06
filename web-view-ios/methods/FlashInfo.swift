//
//  FlashInfo.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 03.05.2025.
//

import AVFoundation
import UIKit

extension App {
    func flashInfo(r: Int, e: String, d: Any) {
        
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            sendError(
                requestID: r,
                event: e,
                key: "NO_TORCH",
                message: "Device has no torch."
            )
            return
        }

        let isOn = device.torchMode == .on

        sendResponse(requestID: r, event: e, data: [
            "is_available": isOn,
            "level": isOn ? device.torchLevel : 0
        ])
        
    }
}
