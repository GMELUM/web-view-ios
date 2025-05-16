//
//  WebViewEvent.swift
//  webview-app
//
//  Created by Артур Гетьман on 08.05.2025.
//

import Foundation
import WebKit

// The WebViewEventHandler protocol defines a blueprint for
// handling specific actions that can be triggered from
// JavaScript messages within the WKWebView context.
// Implementing classes must specify a static action string
// and provide concrete logic in the 'handle' method.
protocol WebViewEventHandler {
    // A static action string that identifies the type of event handled.
    static var action: String { get }
    // A designated initializer with a WebViewController for context.
    init(controller: WebViewController, services: Services)
    // Method to process events, providing request ID, event name, and data payload.
    func handle(r: Int, e: String, d: Any)
}

// The WebViewEvent class is responsible for managing the
// lifecycle and delegation of messages received from JavaScript.
// It serves as a bridge for interpreting and executing actions
// based on events initiated by the web content.
class WebViewEvent {

    // A static array of all handler types that conform to WebViewEventHandler.
    // This list is used to instantiate handlers during initialization.
    private static let handlerTypes: [WebViewEventHandler.Type] = [

        AccelerometerStart.self,
        AccelerometerStop.self,

        AppInfo.self,
        AppStart.self,
        AppVersion.self,
        
        CameraScan.self,

        FlashInfo.self,
        FlashSet.self,

        GyroscopeStart.self,
        GyroscopeStop.self,

        LoaderShow.self,
        LoaderHide.self,
        
        PopupNotification.self,

        TapticImpact.self,
        TapticNotification.self,
        TapticSelection.self,
        
        ScreenIdleTimerOn.self,
        ScreenIdleTimerOff.self,

        StorageGet.self,
        StorageSet.self,
        StorageDelete.self,
        StorageKeys.self,

    ]

    // A weak reference to the WebViewController to avoid retain cycles.
    // The controller is used to send responses and errors back to JavaScript.
    weak var controller: WebViewController!
    weak var services: Services!

    // A dictionary of handlers, mapping event names to their corresponding handlers.
    private var handlers: [String: WebViewEventHandler] = [:]

    // Initializes the WebViewEvent with a given WebViewController.
    // Instantiates handlers based on the static handlerTypes array and associates them with actions.
    init(c: WebViewController, s: Services) {
        self.controller = c
        self.services = s
        for handlerType in Self.handlerTypes {
            handlers[handlerType.action] = handlerType.init(
                controller: c,
                services: s
            )
        }
    }

    // Handles messages received from JavaScript within the web content.
    // Processes message payloads to extract relevant details like request ID, event name, and data.
    // Dispatches control to the appropriate handler based on the event type.
    func handle(message: WKScriptMessage) {

        // Verify the message target and ensure it meets the expected structure and data constraints.
        guard message.name == "nativeapp",
            let messageBody = message.body as? [Any],
            messageBody.count >= 3
        else {
            return
        }

        // Extract critical components from the message for processing.
        let requestID = messageBody[0] as? Int ?? 0
        let event = messageBody[1] as? String ?? ""
        let data = messageBody[2]

        // Attempt to dispatch the event to the dedicated handler; if unavailable, report an error.
        if let handler = handlers[event] {
            handler.handle(r: requestID, e: event, d: data)
        } else {
            controller?.sendError(
                requestID,
                event,
                "UNKNOWN_EVENT",
                "unknown event"
            )
        }

    }
}
