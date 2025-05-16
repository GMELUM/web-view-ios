//
//  GyroscopeStart.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The GyroscopeStart class implements the WebViewEventHandler protocol
// to manage the initiation of gyroscope data streaming triggered via web events.
// It processes configuration parameters and initiates the gyroscope
// updates, relaying received data back to the web context.

class GyroscopeStart: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the GyroscopeStart handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "gyroscope.start" }

    // Handles the event to start gyroscope updates.
    // Extracts configuration settings and initiates updates,
    // sending responses back to the web context.
    func handle(r: Int, e: String, d: Any) {

        // Attempt to extract the refresh rate from the provided data payload.
        guard let dataDictionary = d as? [String: Any],
              let refreshRate = dataDictionary["refresh_rate"] as? Double
        else {
            // Send an error response if the data is incorrectly formatted or missing the refresh rate.
            return controller.sendError(
                r,
                e,
                "INVALID_DATA",
                "Invalid data format or target."
            )
        }

        // Verify that the gyroscope hardware is available on the device.
        if !services.gyroscope.isAvailable() {
            // Send an error response if the gyroscope is unavailable.
            return controller.sendError(
                r,
                e,
                "GYROSCOPE_NOT_AVAILABLE",
                "Gyroscope is not available on this device."
            )
        }

        // Define the onUpdate closure to handle incoming gyroscope data.
        // This will be executed whenever new gyroscope data is available.
        services.gyroscope.onUpdate = { x, y, z in
            // Send a response with the gyroscope readings on each update.
            self.controller.sendResponse(
                0,  // Using 0 as this is a continuous data stream.
                "gyroscope.tick",  // The event name for data updates.
                ["x": x, "y": y, "z": z]
            )
        }

        // Attempt to start the gyroscope updates with the specified refresh rate.
        let success = services.gyroscope.start(delay: refreshRate)

        // Send a response indicating whether the gyroscope was successfully started.
        controller.sendResponse(r, e, ["success": success])
    }
}
