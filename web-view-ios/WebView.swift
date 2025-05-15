import SwiftUI
import WebKit

// The WebView struct serves as a SwiftUI wrapper around a WKWebView.
// It enables the integration of web content within a SwiftUI view hierarchy.
// This struct provides an interface for loading URLs and receiving
// JavaScript messages from the web content through a coordinator.

struct WebView: UIViewRepresentable {
    // The URL to be loaded into the WebView.
    let url: URL
    // An observed object that serves as a controller for managing web interactions.
    @ObservedObject var controller: WebViewController
    @ObservedObject var services: Services

    // Creates a Coordinator instance to manage the WebView's event handling.
    // The coordinator acts as a bridge delegating events from the WebView
    // to the designated event handler by using WKScriptMessageHandler.
    func makeCoordinator() -> Coordinator {
        Coordinator(controller: controller, services: services)
    }

    // Creates and configures the WKWebView instance.
    // This method sets up JavaScript message handling and loads the initial URL.
    func makeUIView(context: Context) -> WKWebView {
        // Configure preferences allowing JavaScript.
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        // Create the WebView configuration and associate it with the user content controller.
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences

        let userContentController = WKUserContentController()
        // Register the script message handler with the name 'nativeapp'.
        userContentController.add(context.coordinator, name: "nativeapp")
        configuration.userContentController = userContentController

        // Instantiate the WKWebView with the configured settings.
        let webView = WKWebView(frame: .zero, configuration: configuration)
        controller.webView = webView

        // Set the coordinator as the navigation delegate.
        webView.navigationDelegate = context.coordinator
        // Initiate loading of the specified URL.
        webView.load(URLRequest(url: url))

        return webView
    }

    // Updates the WKWebView with any necessary state changes.
    // Currently, this method does not alter the view.
    func updateUIView(_ uiView: WKWebView, context: Context) {}

    // The Coordinator class to handle JavaScript messages and navigation events.
    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        // An event handler for processing JavaScript messages.
        let handler: WebViewEvent

        // Initializes the coordinator with a given WebViewController.
        init(controller: WebViewController, services: Services) {
            self.handler = WebViewEvent(c: controller, s: services)
        }

        // Handles incoming messages from the web content.
        // Uses the handler to process each message received.
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            handler.handle(message: message)
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }

            if url.isFileURL {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        }

    }
}
