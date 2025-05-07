//
//  AccelerometerStop.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

extension App {

    // Stops the accelerometer updates.
    // - Parameters:
    //   - r: The request ID associated with this operation.
    //   - e: The event name to identify the request.
    //   - d: The accompanying data payload for the request (not used in this method).
    func accelerometerStop(r: Int, e: String, d: Any) {

        // Check if the accelerometer hardware is available.
        if !accelerometerManager.isAvailable() {
            // If unavailable, send an error response indicating the unavailability of the accelerometer.
            webView.sendError(
                requestID: r,
                event: e,
                key: "ACCELEROMETER_NOT_AVAILABLE",
                message: "Accelerometer is not available on this device."
            )
            return
        }

        // Attempt to stop the accelerometer updates and capture the success status.
        let isSuccess = accelerometerManager.stop()

        // Send a response back to the requester indicating whether stopping the updates was successful.
        webView.sendResponse(requestID: r, event: e, data: ["success": isSuccess])
    }
}
