//
//  AccelerometerStart.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The AccelerometerStart class implements the WebViewEventHandler
// protocol to handle the initiation of accelerometer data streaming
// when triggered by web events. Its responsibility is to extract
// configuration settings from JavaScript messages and manage the
// lifecycle of accelerometer updates.

class AccelerometerStart: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the AccelerometerStart handler with essential
    // context objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "accelerometer.start" }

    // Handles data from incoming web events, configuring and starting
    // accelerometer updates based on provided parameters.
    func handle(r: Int, e: String, d: Any) {

        // Attempt to extract the `refreshRate` from the data payload.
        // This rate determines how frequently the accelerometer updates.
        guard let dataDictionary = d as? [String: Any],
            let refreshRate = dataDictionary["refresh_rate"] as? Double
        else {
            // If extraction fails, send an error response indicating invalid data format.
            return controller.sendError(
                r,
                e,
                "INVALID_DATA",
                "Invalid data format or target."
            )
        }

        // Check if the accelerometer hardware is available on the device.
        if !services.accelerometer.isAvailable() {
            // If not available, send an error response indicating the unavailability of the accelerometer.
            return controller.sendError(
                r,
                e,
                "ACCELEROMETER_NOT_AVAILABLE",
                "Accelerometer is not available on this device."
            )
        }

        // Define the handler to process incoming accelerometer data updates.
        // Sends accelerometer readings (`x`, `y`, `z`) back to the requester.
        services.accelerometer.onUpdate = { x, y, z in
            self.controller.sendResponse(
                0,  // Sending 0 as request ID as this is a continuous data stream.
                "accelerometer.tick",  // Indicating an event that provides periodic accelerometer data.
                ["x": x, "y": y, "z": z]
            )
        }

        // Attempt to start accelerometer updates with the specified refresh rate.
        let success = services.accelerometer.start(delay: refreshRate)

        // Send a response back to the requester indicating whether starting the updates was successful.
        controller.sendResponse(r, e, ["success": success])
    }
}
