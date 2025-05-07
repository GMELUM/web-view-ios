//
//  GyroscopeStop.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

extension App {

    // Stops the gyroscope updates and reports the result back to the requester.
    // - Parameters:
    //   - r: The request ID used to correlate the response with the original request.
    //   - e: The event name that triggered this action.
    //   - d: The data payload associated with the request (not used in this method).
    func gyroscopeStop(r: Int, e: String, d: Any) {

        // Check if the gyroscope is available on the device.
        if !gyroscopeManager.isAvailable() {
            // Send an error if the gyroscope is not available, indicating that it's not present on the device.
            webView.sendError(
                requestID: r,
                event: e,
                key: "GYROSCOPE_NOT_AVAILABLE",
                message: "Gyroscope is not available on this device."
            )
            return
        }

        // Attempt to stop the gyroscope updates.
        let isSuccess = gyroscopeManager.stop()

        // Send a response back indicating whether stopping the gyroscope was successful.
        webView.sendResponse(requestID: r, event: e, data: ["success": isSuccess])
    }
}
