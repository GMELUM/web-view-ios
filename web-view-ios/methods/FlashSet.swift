//
//  FlashLightOn.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 03.05.2025.
//

import AVFoundation
import UIKit

extension App {

    // Sets the flash (torch) level on the device.
    // - Parameters:
    //   - r: The request ID for correlating responses with requests.
    //   - e: The event name that triggered this action.
    //   - d: The data payload expected to include the torch level setting.
    func flashSet(r: Int, e: String, d: Any) {

        // Ensure the device supports video and has a torch capability.
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            // Send an error if the device does not have a flashlight.
            webView.sendError(
                requestID: r,
                event: e,
                key: "NO_TORCH",
                message: "Device has no torch."
            )
            return
        }

        // Extract the desired level from the provided data dictionary.
        guard let dataDictionary = d as? [String: Any],
            let level = dataDictionary["level"] as? Float
        else {
            // Send an error if the data format is invalid or doesn't include the required information.
            webView.sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }

        do {
            // Attempt to lock the device for configuration changes.
            try device.lockForConfiguration()
            print(level)  // Debug: Print the level to console

            switch level {
            case 0:
                // Turn off the torch if the level is 0.
                device.torchMode = .off
            default:
                // Set the torch to the specified level.
                try device.setTorchModeOn(level: level)
            }
            // Unlock the device after configuration.
            device.unlockForConfiguration()
        } catch {
            // Handle any errors during configuration and send an error response.
            webView.sendError(
                requestID: r,
                event: e,
                key: "CONFIGURATION_ERROR",
                message: "Failed to configure the torch."
            )
            return
        }

        // Send a success response once the torch level is successfully set.
        webView.sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
