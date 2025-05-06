//
//  GyroscopeManager.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

import CoreMotion
import Foundation

class GyroscopeManager {

    private let motionManager = CMMotionManager()
    private var isRunning = false
    private var updateInterval: TimeInterval = 1.0

    var onUpdate: ((Double, Double, Double) -> Void)?

    init() {}

    func start(delay: Double) -> Bool {
        guard !isRunning else {
            return false
        }

        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = delay / 1000.0
            motionManager.startGyroUpdates(to: .main) {
                [weak self] data, error in
                if let error = error {
                    return
                }

                if let rotationData = data {
                    self?.isRunning = true
                    self?.onUpdate?(
                        rotationData.rotationRate.x,
                        rotationData.rotationRate.y,
                        rotationData.rotationRate.z
                    )
                }
            }

            return true

        }

        return false
    }

    func stop() -> Bool {
        if isRunning && motionManager.isGyroAvailable {
            motionManager.stopGyroUpdates()
            isRunning = false
            return true
        }
        return false
    }

    func isAvailable() -> Bool {
        return motionManager.isGyroAvailable
    }
}
