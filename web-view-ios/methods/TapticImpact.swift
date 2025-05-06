//
//  Taptic.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

extension App {
    enum ImpactStyle: String {
        case light, medium, heavy, soft, rigid

        var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle {
            print(self)
            switch self {
            case .light: return .light
            case .medium: return .medium
            case .heavy: return .heavy
            case .soft: return .soft
            case .rigid: return .rigid
            }
        }
    }

    func tapticImpact(r: Int, e: String, d: Any) {
        
        guard let dataDict = d as? [String: String],
            let styleString = dataDict["style"],
            let style = ImpactStyle(rawValue: styleString)
        else {
            print("Invalid data format or unsupported style")
            return
        }

        let impactFeedbackGenerator = UIImpactFeedbackGenerator(
            style: style.feedbackStyle
        )
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()

        sendResponse(requestID: r, event: e, data: ["success": true])

    }
}
