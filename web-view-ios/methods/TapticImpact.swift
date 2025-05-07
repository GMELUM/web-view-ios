//
//  Taptic.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {

    // Enumeration representing different styles of haptic feedback impacts.
    enum ImpactStyle: String {
        case light, medium, heavy, soft, rigid

        // Maps the custom ImpactStyle to the corresponding UIImpactFeedbackGenerator.FeedbackStyle.
        var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle {
            print(self)  // Debug: Print the selected impact style
            switch self {
            case .light: return .light
            case .medium: return .medium
            case .heavy: return .heavy
            case .soft: return .soft
            case .rigid: return .rigid
            }
        }
    }

    // Triggers haptic feedback based on the specified impact style.
    // - Parameters:
    //   - r: The request ID to correlate the feedback action with its request.
    //   - e: The event name that triggered this action.
    //   - d: The data payload expected to contain the impact style as a string.
    func tapticImpact(r: Int, e: String, d: Any) {

        // Attempt to extract the impact style from the input data.
        guard let dataDict = d as? [String: String],
            let styleString = dataDict["style"],
            let style = ImpactStyle(rawValue: styleString)
        else {
            print("Invalid data format or unsupported style")  // Log an error for debugging
            return
        }

        // Create and configure a UIImpactFeedbackGenerator with the selected style.
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(
            style: style.feedbackStyle
        )

        // Prepare the feedback generator for use, ensuring haptic feedback occurs immediately.
        impactFeedbackGenerator.prepare()

        // Trigger the haptic feedback.
        impactFeedbackGenerator.impactOccurred()

        // Send a success response indicating the feedback was triggered successfully.
        webView.sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
