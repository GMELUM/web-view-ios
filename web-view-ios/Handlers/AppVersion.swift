//
//  AppVersion.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 10.05.2025.
//

// The AppVersion class implements the WebViewEventHandler protocol
// to handle requests for the application version information.
// When triggered by a specific web event, it retrieves and sends
// the version and build details back to the web context.
class AppVersion: WebViewEventHandler {

    // Weak reference to WebViewController to manage communication with the web view
    // and prevent retain cycles that can lead to memory leaks.
    weak var controller: WebViewController!
    
    // Weak reference to Services to interact with application services
    // efficiently, avoiding strong reference cycles.
    weak var services: Services!

    // Initializes the AppVersion handler with essential contexts:
    // the WebViewController for communication and Services for accessing
    // application-specific functionalities.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // The unique identifier for the action this handler responds to.
    // It associates the handler with the "app.version" event type.
    static var action: String { "app.version" }

    // Handles the event to fetch the app version details.
    // Retrieves the version and build number from the app's metadata
    // and sends this information back to the web interface.
    func handle(r: Int, e: String, d: Any) {
        
        // Retrieve app version and build information through the services.
        let data = services.app.getAppVersion()

        // Send the retrieved version information back as a response.
        controller.sendResponse(r, e, data)
    }
}
