import UIKit
import WebKit

class App: UIViewController {

    var modalManager = ModalManager()
    var storageManager = StorageManager()

    var webView: WKWebView!
    var loaderApp: LoaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        createWebView()

        loaderApp = LoaderView(frame: view.bounds)
        loaderApp.show(on: view)

    }

    func createWebView() {

        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController.add(
            self,
            name: "nativeapp"
        )

        webView = WKWebView(
            frame: .zero,
            configuration: configuration
        )

        webView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            webView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            webView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            webView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
        ])

        if let filePath = Bundle.main.url(
            forResource: "index",
            withExtension: "html"
        ) {
            let fileURL = URLRequest(url: filePath)
            webView.load(fileURL)
        } else {
            print("HTML файл не найден")
        }

    }

}

extension App: WKScriptMessageHandler {
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        print(message)
        if message.name == "nativeapp" {
            if let messageBody = message.body as? [Any] {
                let requestID = messageBody[0] as? Int ?? 0
                let event = messageBody[1] as? String ?? ""
                let data = messageBody[2]

                switch event {

                case "app.start":
                    appStart(r: requestID, e: event, d: data)
                case "loader.show":
                    loaderShow(r: requestID, e: event, d: data)
                case "loader.hide":
                    loaderHide(r: requestID, e: event, d: data)
                case "camera.qr":
                    cameraQR(r: requestID, e: event, d: data)

                case "taptic.impact":
                    tapticImpact(r: requestID, e: event, d: data)
                case "taptic.notification":
                    tapticNotification(r: requestID, e: event, d: data)
                case "taptic.selection":
                    tapticSelection(r: requestID, e: event, d: data)

                case "storage.get":
                    storageGet(r: requestID, e: event, d: data)
                case "storage.set":
                    storageSet(r: requestID, e: event, d: data)
                case "storage.delete":
                    storageDelete(r: requestID, e: event, d: data)
                case "storage.keys":
                    storageKeys(r: requestID, e: event, d: data)

                default:
                    sendError(
                        requestID: requestID,
                        event: event,
                        key: "UNKNOWN_EVENT",
                        message: "unknown event"
                    )
                }

            }
        }
    }

    func sendResponse(requestID: Int, event: String, data: Any) {
        let responseData: [String: Any] = ["response": data]

        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: responseData,
                options: []
            )
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let jsCode =
                    "window._nativeapp_receive(\(requestID), '\(event)', \(jsonString))"
                
                print(jsCode)
                webView.evaluateJavaScript(jsCode, completionHandler: nil)
            }
        } catch {
            print("Failed to serialize response JSON: \(error)")
        }
    }

    func sendError(requestID: Int, event: String, key: String, message: String)
    {
        let errorData: [String: Any] = [
            "error": ["key": key, "message": message]
        ]

        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: errorData,
                options: []
            )
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let jsCode =
                    "window._nativeapp_receive(\(requestID), '\(event)', \(jsonString))"
                print(jsCode)
                webView.evaluateJavaScript(jsCode, completionHandler: nil)
            }
        } catch {
            print("Failed to serialize error JSON: \(error)")
        }
    }

}
