//
//  FlashLightOn.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 03.05.2025.
//

import AVFoundation
import UIKit

extension App {
    func flashSet(r: Int, e: String, d: Any) {

        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch
        else {
            sendError(
                requestID: r,
                event: e,
                key: "NO_TORCH",
                message: "Device has no torch."
            )
            return
        }

        guard let dataDictionary = d as? [String: Any],
            let level = dataDictionary["level"] as? Float
        else {
            sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }

        do {
            try device.lockForConfiguration()
            print(level)
            switch level {
            case 0:
                device.torchMode = .off
            default:
                try device.setTorchModeOn(level: level)
            }
            device.unlockForConfiguration()
        } catch {
            sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }

        sendResponse(requestID: r, event: e, data: ["success": true])

    }
}
