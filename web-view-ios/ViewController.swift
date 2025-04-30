import UIKit
import WebKit

class App: UIViewController {

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

        // Загружаем локальный HTML файл из папки html
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
                    appStart()
                case "loader.show":
                    loaderShow()
                case "loader.hide":
                    self.loaderApp.hide()
                default:
                    print("unknown event")
                    break
                }

                let response = "Ответ от native app"
                let jsCode =
                    "window._nativeapp_receive(\(requestID), '\(response)')"
                webView.evaluateJavaScript(jsCode, completionHandler: nil)
            }
        }
    }
}
