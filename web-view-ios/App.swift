import UIKit
import WebKit

class App: UIViewController {

    var modalManager = ModalManager()
    var storageManager = StorageManager()
    var accelerometerManager = AccelerometerManager()
    var gyroscopeManager = GyroscopeManager()

    var webView: WebView!
    var loaderApp: LoaderView!
    var observer: AppObserver!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WebView(frame: view.bounds)
        webView.attach(to: view, delegate: self)

        loaderApp = LoaderView(frame: view.bounds)
        loaderApp.show(on: view)

        observer = AppObserver(self)

        webView.loadLocalHTML(named: "index")
        //        webView.loadRemoteURL("https://dev.elum.app/front")

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

extension App: WebViewContainerDelegate {
    func webViewContainer(
        _ container: WebView,
        didReceiveScriptMessage message: WKScriptMessage
    ) {

        guard message.name == "nativeapp",
            let messageBody = message.body as? [Any],
            messageBody.count >= 3
        else {
            return
        }

        let requestID = messageBody[0] as? Int ?? 0
        let event = messageBody[1] as? String ?? ""
        let data = messageBody[2]

        switch event {
        case "app.start":
            appStart(r: requestID, e: event, d: data)
        case "app.info":
            appInfo(r: requestID, e: event, d: data)
        case "loader.show":
            loaderShow(r: requestID, e: event, d: data)
        case "loader.hide":
            loaderHide(r: requestID, e: event, d: data)
        case "camera.scanQR":
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
            webView.sendError(
                requestID: requestID,
                event: event,
                key: "UNKNOWN_EVENT",
                message: "unknown event"
            )
        }

    }

}
