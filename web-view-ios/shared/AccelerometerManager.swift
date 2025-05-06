//
//  AccelerometerManager.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

import CoreMotion
import Foundation

class AccelerometerManager {

    private let motionManager = CMMotionManager()
    private var isRunning = false
    private var updateInterval: TimeInterval = 1.0

    var onUpdate: ((Double, Double, Double) -> Void)?

    init() {}

    func start(delay: Double) -> Bool {
        guard !isRunning else { return false }

        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = delay / 1000.0
            motionManager.startAccelerometerUpdates(to: .main) {
                [weak self] data, error in
                if let error = error {
                    print("Accelerometer Error: \(error.localizedDescription)")
                    return
                }

                if let data = data {
                    self?.isRunning = true
                    self?.onUpdate?(
                        data.acceleration.x,
                        data.acceleration.y,
                        data.acceleration.z
                    )
                }
            }

            return true

        }

        return false

    }

    func stop() -> Bool {
        if isRunning && motionManager.isAccelerometerAvailable {
            motionManager.stopAccelerometerUpdates()
            isRunning = false
            return true
        }
        return false
    }

    func isAvailable() -> Bool {
        return motionManager.isAccelerometerAvailable
    }

}
