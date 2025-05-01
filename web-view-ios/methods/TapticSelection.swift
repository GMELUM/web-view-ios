//
//  Taptic.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {
    func tapticSelection(r: Int, e: String, d: Any) {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
