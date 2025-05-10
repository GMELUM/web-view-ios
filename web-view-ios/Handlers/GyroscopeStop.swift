//
//  GyroscopeStop.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The GyroscopeStop class implements the WebViewEventHandler protocol
// to manage the termination of gyroscope data streaming, triggered
// by web events. Its role is to cease the active updates from the gyroscope
// and inform the web context of the operation's outcome.

class GyroscopeStop: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the GyroscopeStop handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "gyroscope.stop" }

    // Handles the event to stop gyroscope updates.
    // Verifies the availability of the gyroscope and attempts to
    // terminate ongoing updates, communicating the success or failure
    // back to the web context.
    func handle(r: Int, e: String, d: Any) {

        // Check if the gyroscope is available on the device.
        if !services.gyroscope.isAvailable() {
            // Send an error if the gyroscope is not available, indicating that it's not present on the device.
            return controller.sendError(
                r,
                e,
                "GYROSCOPE_NOT_AVAILABLE",
                "Gyroscope is not available on this device."
            )
        }

        // Attempt to stop the gyroscope updates.
        let success = services.gyroscope.stop()

        // Send a response back indicating whether stopping the gyroscope was successful.
        controller.sendResponse(r, e, ["success": success])

    }
}
