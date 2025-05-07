//
//  AccelerometerManager.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

import CoreMotion
import Foundation

// A class responsible for managing accelerometer updates using CoreMotion framework.
class AccelerometerManager {

    // The motion manager instance that provides accelerometer data.
    private let motionManager = CMMotionManager()

    // Indicates whether accelerometer updates are currently running.
    private var isRunning = false

    // The desired update interval for accelerometer data in seconds.
    private var updateInterval: TimeInterval = 1.0

    // A closure to be called with updated accelerometer data (x, y, z axis).
    var onUpdate: ((Double, Double, Double) -> Void)?

    // Initializes a new instance of `AccelerometerManager`.
    init() {}

    // Starts accelerometer updates with a specified delay and returns a boolean indicating success.
    // - Parameter delay: The interval in milliseconds between accelerometer updates.
    // - Returns: A boolean indicating whether the accelerometer was successfully started.
    func start(delay: Double) -> Bool {
        // Ensure the accelerometer is not already running before starting it.
        guard !isRunning, motionManager.isAccelerometerAvailable else {
            return false
        }

        // Set the update interval by converting the delay from milliseconds to seconds.
        motionManager.accelerometerUpdateInterval = delay / 1000.0

        // Start accelerometer updates on the main thread.
        motionManager.startAccelerometerUpdates(to: .main) {
            [weak self] data, error in
            // Handle any errors returned from the accelerometer updates.
            if error != nil {
                return
            }

            // Safely unwrap the accelerometer data and update the isRunning state.
            if let data = data {
                self?.isRunning = true
                self?.onUpdate?(
                    data.acceleration.x,
                    data.acceleration.y,
                    data.acceleration.z
                )
            }
        }

        // Return false if the accelerometer is not available or failed to start.
        return true
    }

    // Stops accelerometer updates and returns a boolean indicating success.
    // - Returns: A boolean indicating whether the accelerometer was successfully stopped.
    func stop() -> Bool {
        // Check if the accelerometer is running and hardware is available before stopping.
        if isRunning && motionManager.isAccelerometerAvailable {
            // Stop accelerometer updates.
            motionManager.stopAccelerometerUpdates()

            // Update the state to reflect that updates are no longer running.
            isRunning = false

            // Return true indicating that the updates were successfully stopped.
            return true
        }

        // Return false if the updates were not running.
        return false
    }

    // Checks if the accelerometer is available on the device.
    // - Returns: A boolean indicating accelerometer availability.
    func isAvailable() -> Bool {
        return motionManager.isAccelerometerAvailable
    }
}
