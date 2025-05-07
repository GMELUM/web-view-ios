//
//  GyroscopeStart.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

extension App {

    // Initializes and starts the gyroscope with a specified refresh rate.
    // - Parameters:
    //   - r: The request ID used to associate the response with the request.
    //   - e: The event name that initiated this action.
    //   - d: The data payload expected to contain configuration settings such as the refresh rate.
    func gyroscopeStart(r: Int, e: String, d: Any) {

        // Attempt to extract the refresh rate from the provided data payload.
        guard let dataDictionary = d as? [String: Any],
            let refreshRate = dataDictionary["refresh_rate"] as? Double
        else {
            // Send an error response if the data is incorrectly formatted or missing the refresh rate.
            webView.sendError(
                requestID: r,
                event: e,
                key: "INVALID_DATA",
                message: "Invalid data format or target."
            )
            return
        }

        // Verify that the gyroscope hardware is available on the device.
        if !gyroscopeManager.isAvailable() {
            // Send an error response if the gyroscope is unavailable.
            webView.sendError(
                requestID: r,
                event: e,
                key: "GYROSCOPE_NOT_AVAILABLE",
                message: "Gyroscope is not available on this device."
            )
            return
        }

        // Define the onUpdate closure to handle incoming gyroscope data.
        // This will be executed whenever new gyroscope data is available.
        gyroscopeManager.onUpdate = { x, y, z in
            // Send a response with the gyroscope readings on each update.
            self.webView.sendResponse(
                requestID: 0,  // Using 0 as this is a continuous data stream.
                event: "gyroscope.tick",  // The event name for data updates.
                data: ["x": x, "y": y, "z": z]
            )
        }

        // Attempt to start the gyroscope updates with the specified refresh rate.
        let isSuccess = gyroscopeManager.start(delay: refreshRate)

        // Send a response indicating whether the gyroscope was successfully started.
        webView.sendResponse(requestID: r, event: e, data: ["success": isSuccess])
    }
}
