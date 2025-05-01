//
//  Taptic.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {
    
    enum NotificationType: String {
        case success, warning, error

        var feedbackType: UINotificationFeedbackGenerator.FeedbackType {
            switch self {
            case .success: return .success
            case .warning: return .warning
            case .error: return .error
            }
        }
    }
    
    func tapticNotification(_ data: Any) {
        guard let dataDict = data as? [String: String],
              let typeString = dataDict["type"],
              let type = NotificationType(rawValue: typeString) else {
            print("Invalid data format or unsupported type")
            return
        }

        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(type.feedbackType)
    }
}
