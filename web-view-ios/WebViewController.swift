//
//  WebViewController.swift
//  webview-app
//
//  Created by Артур Гетьман on 08.05.2025.
//

import Combine
import Foundation
import WebKit

// The WebViewController class is designed to act as an intermediary
// between native Swift code and JavaScript within a WKWebView.
// It enables bi-directional communication through JavaScript evaluation.

// This class is an ObservableObject, enabling it to bind
// to SwiftUI views for observing changes in web interaction.
class WebViewController: ObservableObject {

    // The webView property holds an optional WKWebView instance.
    // It's used for executing JavaScript within the context of the page currently loaded.
    public var webView: WKWebView?

    // The executeMethod specifies the JavaScript method to call
    // when sending responses or errors back to the web context.
    private var executeMethod = "window.__nr"

    // Sends a structured response back to the web page by executing JavaScript.
    // Accepts a requestID to correlate responses, an event string, and additional data.
    func sendResponse(_ requestID: Int, _ event: String, _ data: Any) {
        let responseData = ["response": data]
        guard let jsonString = serializeJSON(responseData) else { return }

        let jsCode = "\(executeMethod)(\(requestID), '\(event)', \(jsonString))"
        print(jsCode)
        webView?.evaluateJavaScript(jsCode, completionHandler: nil)
    }

    // Sends an error message to the web page with a given key and description.
    // Mirrors the structure of a response, marked explicitly as an error.
    func sendError(
        _ requestID: Int,
        _ event: String,
        _ key: String,
        _ message: String
    ) {
        let errorData = ["error": ["key": key, "message": message]]
        guard let jsonString = serializeJSON(errorData) else { return }

        let jsCode = "\(executeMethod)(\(requestID), '\(event)', \(jsonString))"
        print(jsCode)
        webView?.evaluateJavaScript(jsCode, completionHandler: nil)
    }

    // Serializes a Swift dictionary into a JSON string representation.
    // Useful for converting data and error structures into a format consumable by JavaScript.
    private func serializeJSON(_ object: Any) -> String? {
        guard
            let data = try? JSONSerialization.data(
                withJSONObject: object,
                options: []
            ),
            let json = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        return json
    }

}
