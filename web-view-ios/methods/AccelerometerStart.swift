//
//  AccelerometerStart.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

extension App {

    // Starts the accelerometer updates based on the provided parameters.
    // - Parameters:
    //   - r: The request ID associated with this operation.
    //   - e: The event name to identify the request.
    //   - d: The data payload, expected to include the refresh rate for accelerometer updates.
    func accelerometerStart(r: Int, e: String, d: Any) {

        // Attempt to extract the `refreshRate` from the data payload.
        guard let dataDictionary = d as? [String: Any],
            let refreshRate = dataDictionary["refresh_rate"] as? Double
        else {
            // If extraction fails, send an error response indicating invalid data format.
            webView.sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }

        // Check if the accelerometer hardware is available on the device.
        if !accelerometerManager.isAvailable() {
            // If not available, send an error response indicating the unavailability of the accelerometer.
            webView.sendError(
                requestID: r,
                event: e,
                key: "ACCELEROMETER_NOT_AVAILABLE",
                message: "Accelerometer is not available on this device."
            )
            return
        }

        // Define the handler to process incoming accelerometer data updates.
        // Sends accelerometer readings (`x`, `y`, `z`) back to the requester.
        accelerometerManager.onUpdate = { x, y, z in
            self.webView.sendResponse(
                requestID: 0,  // Sending 0 as request ID as this is a continuous data stream.
                event: "accelerometer.tick",  // Indicating an event that provides periodic accelerometer data.
                data: ["x": x, "y": y, "z": z]
            )
        }

        // Attempt to start accelerometer updates with the specified refresh rate.
        let isSuccess = accelerometerManager.start(delay: refreshRate)

        // Send a response back to the requester indicating whether starting the updates was successful.
        webView.sendResponse(requestID: r, event: e, data: ["success": isSuccess])
    }
}
