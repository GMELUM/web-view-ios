//
//  Taptic.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

import Combine
import SwiftUI

// The TapticService class is responsible for generating haptic feedback
// on an iOS device using the UIImpactFeedbackGenerator and
// UINotificationFeedbackGenerator provided by the UIKit framework.
// It exposes methods for impact, notification, and selection feedback.

final class TapticService: ObservableObject {

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

    // Generates impact feedback based on the provided input style string.
    // - Parameter input: A string representing the impact style (e.g., "light", "medium").
    // - Returns: A boolean indicating whether the impact feedback was successfully triggered.
    func impact(_ input: String) -> Bool {

        // Attempt to extract the impact style from the input data.
        guard let style = ImpactStyle(rawValue: input) else {
            return false
        }

        // Create and configure a UIImpactFeedbackGenerator with the selected style.
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(
            style: style.feedbackStyle
        )

        // Prepare the feedback generator for use, ensuring haptic feedback occurs immediately.
        impactFeedbackGenerator.prepare()

        // Trigger the haptic feedback.
        impactFeedbackGenerator.impactOccurred()

        return true
    }

    // Generates notification feedback based on the provided input type string.
    // - Parameter input: A string representing the notification type (e.g., "success", "warning").
    // - Returns: A boolean indicating whether the notification feedback was successfully triggered.
    func notification(_ input: String) -> Bool {

        // Attempt to extract the notification type from the input data.
        guard let type = NotificationType(rawValue: input) else {
            return false
        }

        // Create and configure a UINotificationFeedbackGenerator for the specified type.
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()

        // Prepare the feedback generator to ensure the haptic feedback is prompt.
        notificationFeedbackGenerator.prepare()

        // Trigger the notification feedback with the specified type.
        notificationFeedbackGenerator.notificationOccurred(type.feedbackType)

        return true
    }

    // Generates selection change feedback.
    // Provides subtle haptic feedback to indicate a change in selection.
    // - Returns: A boolean indicating whether the selection feedback was successfully triggered.
    func selection() -> Bool {

        // Create and configure a UISelectionFeedbackGenerator which is used to give feedback during a selection change.
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

        // Prepare the feedback generator to ensure that the haptic feedback is prompt.
        selectionFeedbackGenerator.prepare()

        // Trigger the selection change feedback, providing a subtle haptic feedback to the user.
        selectionFeedbackGenerator.selectionChanged()

        return true
    }
}
