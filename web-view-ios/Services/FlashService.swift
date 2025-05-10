//
//  FlashService.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

import AVFoundation
import Foundation

// The FlashService class is responsible for managing and querying
// the state of the device's torch (flashlight). It provides methods
// for obtaining current torch information and setting torch levels,
// ensuring smooth interaction with device hardware capabilities.

final class FlashService: ObservableObject {

    // Returns a dictionary containing information about the current
    // state of the torch, including its availability and brightness level.
    // - Returns: A dictionary with keys indicating if the torch is available
    //   and its current brightness level.
    func info() -> [String: Any] {

        // Attempt to access the device's video capture capabilities, specifically checking for a torch.
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            return [
                // Indicates if the torch (flashlight) is currently inactive.
                "is_available": false,

                // Returns the torch brightness level, defaulted to 0 if not active.
                "level": 0,
            ]
        }

        // Check if the torch is currently on.
        let isOn = device.torchMode == .on

        return [
            // Indicates if the torch (flashlight) is currently active.
            "is_available": isOn,

            // Provides the current level of torch brightness if it's on, otherwise 0.
            "level": isOn ? device.torchLevel : 0,
        ]

    }

    // Adjusts the torch to the specified brightness level.
    // - Parameter level: A Float value representing the desired torch brightness, ranging from 0 (off) to full brightness.
    // - Returns: A boolean indicating the success of setting the torch brightness.
    func set(_ level: Float) -> Bool {

        // Ensure the device supports video capture and has torch capabilities.
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            return false
        }

        do {
            // Attempt to lock the device for configuration changes.
            try device.lockForConfiguration()

            switch level {
            case 0:
                // Turn off the torch if the desired level is 0.
                device.torchMode = .off
            default:
                // Set the torch to the specified brightness level.
                try device.setTorchModeOn(level: level)
            }
            // Unlock the device after making configuration changes.
            device.unlockForConfiguration()
        } catch {
            return false
        }

        // Return true if setting the torch level was successful.
        return true
    }
}
