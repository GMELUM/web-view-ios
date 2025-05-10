//
//  AccelerometerStop.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The AccelerometerStop class implements the WebViewEventHandler
// protocol to handle the termination of accelerometer data streaming
// when triggered by web events. Its responsibility is to stop the
// active accelerometer updates and inform the web context of the outcome.

class AccelerometerStop: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the AccelerometerStop handler with essential
    // context objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "accelerometer.stop" }

    // Handles the event to stop accelerometer updates.
    // Verifies availability of the hardware and attempts to terminate updates,
    // then communicates the success or failure back to the web context.
    func handle(r: Int, e: String, d: Any) {

        // Check if the accelerometer hardware is available.
        if !services.accelerometer.isAvailable() {
            // If unavailable, send an error response indicating the unavailability of the accelerometer.
            return controller.sendError(
                r,
                e,
                "ACCELEROMETER_NOT_AVAILABLE",
                "Accelerometer is not available on this device."
            )
        }

        // Attempt to stop the accelerometer updates and capture the success status.
        let success = services.accelerometer.stop()

        // Send a response back to the requester indicating whether stopping the updates was successful.
        controller.sendResponse(r, e, ["success": success])
    }
}
