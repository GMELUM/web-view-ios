//
//  ScreenIdleTimerOn.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 10.05.2025.
//

// The ScreenIdleTimerOn class implements the WebViewEventHandler protocol.
// It handles web events to enable the device's screen idle timer,
// ensuring that the screen remains active and does not dim
// or lock automatically due to inactivity.
class ScreenIdleTimerOn: WebViewEventHandler {
    
    // Weak reference to WebViewController to prevent strong reference cycles.
    weak var controller: WebViewController!
    
    // Weak reference to Services to prevent strong reference cycles.
    weak var services: Services!

    // Initializes the ScreenIdleTimerOn handler with references to
    // the controller and services, enabling it to manage events and
    // interact with the app's services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // The static action identifier associated with this handler.
    // It is used to link incoming web events requesting to
    // keep the screen from idling to this handler.
    static var action: String { "screen.idleTimerOn" }

    // Handles the incoming event to enable the screen idle timer.
    // The device's screen will remain active and not dim.
    // Once the operation is performed, it sends confirmation back to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Enables the screen to remain always on by disabling the idle timer.
        services.screen.enableScreenAlwaysOn()
        
        // Send a response back to the web view indicating successful operation.
        controller.sendResponse(r, e, ["success": true])
    }
}
