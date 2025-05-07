//
//  WebView.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 06.05.2025.
//

import UIKit
import WebKit

/// Delegate protocol for receiving JavaScript messages from the web content.
protocol WebViewContainerDelegate: AnyObject {
    func webViewContainer(
        _ container: WebView,
        didReceiveScriptMessage message: WKScriptMessage
    )
}

/// A UIView subclass encapsulating a fully managed WKWebView instance.
class WebView: UIView {

    // MARK: - Properties

    private let webView: WKWebView
    weak var delegate: WebViewContainerDelegate?

    // MARK: - Initialization

    override init(frame: CGRect) {
        // Configure preferences for JavaScript
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        // Create the web view configuration
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences

        // Setup the user content controller for JS <-> Native messaging
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController

        self.webView = WKWebView(frame: .zero, configuration: configuration)
        super.init(frame: frame)

        // Register the script message handler
        userContentController.add(self, name: "nativeapp")

        setupWebViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    /// Configures webView layout within the custom view.
    private func setupWebViewLayout() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    /// Attaches the WebView to a parent view and optionally sets a delegate.
    func attach(to parent: UIView, delegate: WebViewContainerDelegate? = nil) {
        self.delegate = delegate
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            topAnchor.constraint(equalTo: parent.topAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
    }

    // MARK: - Public API

    // Loads a local HTML file bundled with the app.
    func loadLocalHTML(named filename: String, withExtension ext: String = "html") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            print("❗️HTML file '\(filename).\(ext)' not found in the app bundle.")
            return
        }

        webView.loadFileURL(url, allowingReadAccessTo: url)
    }

    // Loads a remote web URL.
    func loadRemoteURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("❗️Invalid URL: \(urlString)")
            return
        }

        webView.load(URLRequest(url: url))
    }

    // Evaluates arbitrary JavaScript in the web context.
    func evaluateJavaScript(_ js: String) {
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    // Sends a structured response back to the web context.
    func sendResponse(requestID: Int, event: String, data: Any) {
        let responseData = ["response": data]

        guard let jsonString = serializeJSON(responseData) else { return }

        let jsCode = "window._nativeapp_receive(\(requestID), '\(event)', \(jsonString))"
        print(jsCode)
        webView.evaluateJavaScript(jsCode, completionHandler: nil)
    }

    // Sends an error back to the web context with a custom key and message.
    func sendError(requestID: Int, event: String, key: String, message: String) {
        let errorData = [
            "error": ["key": key, "message": message]
        ]

        guard let jsonString = serializeJSON(errorData) else { return }

        let jsCode = "window._nativeapp_receive(\(requestID), '\(event)', \(jsonString))"
        print(jsCode)
        webView.evaluateJavaScript(jsCode, completionHandler: nil)
    }

    // MARK: - Helpers

    // Serializes a Swift dictionary into a JSON string.
    private func serializeJSON(_ object: Any) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("❗️JSON serialization failed: \(error)")
            return nil
        }
    }
}

// MARK: - WKScriptMessageHandler

extension WebView: WKScriptMessageHandler {
    // Handles messages received from JavaScript inside the web page.
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        delegate?.webViewContainer(self, didReceiveScriptMessage: message)
    }
}
