//
//  Taptic.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {

    // Enumeration representing different types of notification feedback.
    enum NotificationType: String {
        case success, warning, error

        // Maps the custom NotificationType to the corresponding UINotificationFeedbackGenerator.FeedbackType.
        var feedbackType: UINotificationFeedbackGenerator.FeedbackType {
            switch self {
            case .success: return .success
            case .warning: return .warning
            case .error: return .error
            }
        }
    }

    // Triggers notification haptic feedback based on the specified notification type.
    // - Parameters:
    //   - r: The request ID to correlate the feedback action with its request.
    //   - e: The event name that triggered this action.
    //   - d: The data payload expected to contain the notification type as a string.
    func tapticNotification(r: Int, e: String, d: Any) {

        // Attempt to extract the notification type from the input data.
        guard let dataDict = d as? [String: String],
            let typeString = dataDict["type"],
            let type = NotificationType(rawValue: typeString)
        else {
            // Log an error message if data format is invalid or type is unsupported.
            print("Invalid data format or unsupported type")
            return
        }

        // Create and configure a UINotificationFeedbackGenerator for the specified type.
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()

        // Prepare the feedback generator to ensure the haptic feedback is prompt.
        notificationFeedbackGenerator.prepare()

        // Trigger the notification feedback with the specified type.
        notificationFeedbackGenerator.notificationOccurred(type.feedbackType)

        // Send a success response indicating the feedback was executed successfully.
        webView.sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
