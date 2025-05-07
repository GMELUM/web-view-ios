//
//  Taptic.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {

    // Triggers a selection change haptic feedback to enhance the user experience during selection interactions.
    // - Parameters:
    //   - r: The request ID used to correlate this feedback action with a specific request.
    //   - e: The event name that triggered this action, potentially indicating the context of the selection.
    //   - d: The data payload associated with the request (not used in this method).
    func tapticSelection(r: Int, e: String, d: Any) {

        // Create and configure a UISelectionFeedbackGenerator which is used to give feedback during a selection change.
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

        // Prepare the feedback generator to ensure that the haptic feedback is prompt.
        selectionFeedbackGenerator.prepare()

        // Trigger the selection change feedback, providing a subtle haptic feedback to the user.
        selectionFeedbackGenerator.selectionChanged()

        // Send a success response indicating the feedback was triggered successfully.
        webView.sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
