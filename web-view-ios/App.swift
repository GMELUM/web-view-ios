import UIKit
import WebKit

class App: UIViewController {

    var modalManager = ModalManager()
    var storageManager = StorageManager()
    var accelerometerManager = AccelerometerManager()
    var gyroscopeManager = GyroscopeManager()

    var webView: WKWebView!
    var loaderApp: LoaderView!
    var observer: AppObserver!

    override func viewDidLoad() {
        super.viewDidLoad()

        createWebView()

        loaderApp = LoaderView(frame: view.bounds)
        loaderApp.show(on: view)

        observer = AppObserver(self)

    }

    func createWebView() {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController.add(self, name: "nativeapp")

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }

//        if let url = URL(string: "https://dev.elum.app/front") {
//            let urlRequest = URLRequest(url: url)
//            webView.load(urlRequest)
//        } else {
//            print("Неверный URL")
//        }
    }

    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(
                comparedTo: previousTraitCollection
            ) {
                appUpdate(r: 0, e: "system.update", d: [:])
            }
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

                print("event: \(event) data: \(data)")

                switch event {
                case "app.start":
                    appStart(r: requestID, e: event, d: data)
                case "app.info":
                    appInfo(r: requestID, e: event, d: data)
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
                case "flash.set":
                    flashSet(r: requestID, e: event, d: data)
                case "flash.info":
                    flashInfo(r: requestID, e: event, d: data)
                case "accelerometer.start":
                    accelerometerStart(r: requestID, e: event, d: data)
                case "accelerometer.stop":
                    accelerometerStop(r: requestID, e: event, d: data)
                case "gyroscope.start":
                    gyroscopeStart(r: requestID, e: event, d: data)
                case "gyroscope.stop":
                    gyroscopeStop(r: requestID, e: event, d: data)
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
