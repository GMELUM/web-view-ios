//
//  AccelerometerStop.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

extension App {
    func accelerometerStop(r: Int, e: String, d: Any) {

        if !accelerometerManager.isAvailable() {
            sendError(
                requestID: r,
                event: e,
                key: "ACCELEROMETER_NOT_AVAILABLE",
                message: "Accelerometer is not available on this device."
            )
            return
        }

        var isSuccess = accelerometerManager.stop()

        sendResponse(requestID: r, event: e, data: ["success": isSuccess])

    }
}
