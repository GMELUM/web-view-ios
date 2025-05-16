//
//  AppInfo.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

// The AppInfo class implements the WebViewEventHandler protocol
// to handle requests for application metadata via web events.
// Its responsibility is to gather relevant application information
// and communicate success status back to the web context.

class AppInfo: WebViewEventHandler {
    // References to the WebViewController and Services, held weakly
    // to prevent retain cycles and manage memory efficiently.
    weak var controller: WebViewController!
    weak var services: Services!

    // Initializes the AppInfo handler with necessary context
    // objects for managing events and services.
    required init(controller: WebViewController, services: Services) {
        self.controller = controller
        self.services = services
    }

    // Static identifier for the action that this handler responds to.
    // Used to match incoming web events to this handler.
    static var action: String { "app.info" }

    // Handles the event to retrieve application information.
    // It interacts with service components to fetch data
    // and communicates success to the web context.
    func handle(r: Int, e: String, d: Any) {
        
        // Retrieve application information and convey it to the web context.
        let appInfo = services.systemInfo.info()
        controller.sendResponse(r, e, appInfo)
        
    }
}
