//
//  CameraScanQR.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

extension App {
    func cameraQR(r: Int, e: String, d: Any) {
        let modalVC = ModalViewController()
        modalManager.open(modal: modalVC, from: self) { data in
            if let result = data as? String {
                self.webView.sendResponse(
                    requestID: r,
                    event: e,
                    data: ["text": result]
                )
            }
        }
    }
}
