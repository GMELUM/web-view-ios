//
//  GyroscopeService.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

import CoreMotion
import Foundation

// A manager class for handling gyroscope data updates using CoreMotion framework.
class GyroscopeService: ObservableObject {

    // CoreMotion manager instance to access device motion data.
    private let motionManager = CMMotionManager()
    
    // Indicates whether gyroscope updates are currently running.
    private var isRunning = false
    
    // The desired interval between gyroscope data updates, in seconds.
    private var updateInterval: TimeInterval = 1.0

    // A closure property that gets called with updated gyroscope data (x, y, z rates).
    var onUpdate: ((Double, Double, Double) -> Void)?

    // Initializes a new instance of `GyroscopeManager`.
    init() {}

    // Starts the gyroscope updates with the specified update delay.
    // - Parameter delay: The interval in milliseconds for receiving gyroscope updates.
    // - Returns: A boolean indicating whether the gyroscope was successfully started.
    func start(delay: Double) -> Bool {
        
        // Ensure gyroscope updates are not already in progress and that the gyroscope is available.
        guard !isRunning, motionManager.isGyroAvailable else {
            return false
        }
        
        // Set the gyroscope update interval in seconds.
        motionManager.gyroUpdateInterval = delay / 1000.0
        
        // Start receiving gyroscope data updates on the main thread.
        motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
            
            // Ensure there's no error and valid data is received.
            guard error == nil, let rotationData = data else {
                return
            }
            
            // Mark the updates as running and invoke the update closure with new data.
            self?.isRunning = true
            self?.onUpdate?(
                rotationData.rotationRate.x,
                rotationData.rotationRate.y,
                rotationData.rotationRate.z
            )
        }
        
        // Return true indicating that the gyroscope updates were successfully started.
        return true
    }

    /// Stops the gyroscope updates.
    /// - Returns: A boolean indicating whether the gyroscope was successfully stopped.
    func stop() -> Bool {
        // Ensure gyroscope updates are running and hardware is available before stopping.
        if isRunning && motionManager.isGyroAvailable {
            // Invoke stop on gyroscope updates.
            motionManager.stopGyroUpdates()
            
            // Update the state to reflect that updates have stopped.
            isRunning = false
            
            // Return true indicating successful stopping of updates.
            return true
        }
        
        // Return false if updates were not running.
        return false
    }

    /// Checks the availability of gyroscope data.
    /// - Returns: A boolean indicating whether the gyroscope is available on the device.
    func isAvailable() -> Bool {
        return motionManager.isGyroAvailable
    }
}
