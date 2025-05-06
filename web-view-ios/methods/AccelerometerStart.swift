//
//  AccelerometerStart.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

extension App {
    func accelerometerStart(r: Int, e: String, d: Any) {

        guard let dataDictionary = d as? [String: Any],
            let refreshRate = dataDictionary["refresh_rate"] as? Double
        else {
            sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }

        if !accelerometerManager.isAvailable() {
            sendError(
                requestID: r,
                event: e,
                key: "ACCELEROMETER_NOT_AVAILABLE",
                message: "Accelerometer is not available on this device."
            )
            return
        }

        accelerometerManager.onUpdate = { x, y, z in
            self.sendResponse(
                requestID: 0,
                event: "accelerometer.tick",
                data: ["x": x, "y": y, "z": z]
            )
        }

        var isSuccess = accelerometerManager.start(delay: refreshRate)

        sendResponse(requestID: r, event: e, data: ["success": isSuccess])

    }
}
