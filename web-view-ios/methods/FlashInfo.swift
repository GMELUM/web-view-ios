//
//  FlashInfo.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 03.05.2025.
//

import AVFoundation
import UIKit

extension App {

    // Retrieves information about the device's torch (flashlight) status and availability.
    // - Parameters:
    //   - r: The request ID used to correlate the response with the original request.
    //   - e: The event name indicating the context or type of request.
    //   - d: The data payload associated with the request (not used in this method).
    func flashInfo(r: Int, e: String, d: Any) {

        // Attempt to access the device's video capture capabilities, specifically checking for a torch.
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            // Send an error response if no torch is available on the device.
            webView.sendError(
                requestID: r,
                event: e,
                key: "NO_TORCH",
                message: "Device has no torch."
            )
            return
        }

        // Determine if the torch is currently on.
        let isOn = device.torchMode == .on

        // Send back a response indicating whether the torch is available and its current brightness level.
        webView.sendResponse(
            requestID: r, event: e,
            data: [
                // Indicates if the torch (flashlight) is currently active.
                "is_available": isOn,

                // Provides the current level of the torch brightness if it's on, otherwise 0.
                "level": isOn ? device.torchLevel : 0,
            ])
    }
}
