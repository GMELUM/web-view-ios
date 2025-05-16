//
//  ScreenIdleTimerOff.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 10.05.2025.
//

// The ScreenIdleTimerOff class implements the WebViewEventHandler protocol
// to handle requests to disable the device's screen idle timer.
// This action allows the device to revert back to its default behavior,
// where the screen can dim and lock automatically due to inactivity.
class ScreenIdleTimerOff: WebViewEventHandler {
    
    // Weak reference to WebViewController to prevent strong reference cycles.
    weak var controller: WebViewController!
    
    // Weak reference to Services to prevent strong reference cycles.
    weak var services: Services!

    // Initializes the ScreenIdleTimerOff handler with references to
    // the controller and services, enabling it to manage events and
    // interact with the app's services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // The static action identifier associated with this handler.
    // It is used to link incoming web events requesting to
    // allow the screen to idle to this handler.
    static var action: String { "screen.idleTimerOff" }

    // Handles the incoming event to disable the screen idle timer.
    // This allows the device's screen to dim and lock based on
    // the system's default inactivity settings. Once the operation
    // is performed, it sends confirmation back to the web context.
    func handle(r: Int, e: String, d: Any) {
        // Disables the always on screen mode, allowing the idle timer to function.
        services.screen.disableScreenAlwaysOn()
        
        // Send a response back to the web view indicating successful operation.
        controller.sendResponse(r, e, ["success": true])
    }
}
