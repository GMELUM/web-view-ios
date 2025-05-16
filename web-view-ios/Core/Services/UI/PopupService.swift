//
//  NotificationService.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 14.05.2025.
//

import Combine
import SwiftUI

enum NotificationPosition: String {
    case top
    case bottom
}

final class PopupService: ObservableObject {

    @Published private(set) var topNotification: [NotificationData] = []
    @Published private(set) var bottomNotification: [NotificationData] = []
    
    @Published var notificationHeights: [UUID: CGFloat] = [:]

    private var lastIndex: Double = 1e9

    func add(
        icon: String? = nil,
        title: String,
        message: String,
        position: NotificationPosition = .top,
        duration: Double = 5
    ) {

        lastIndex -= 1

        let item = NotificationData(
            icon: icon,
            title: title,
            message: message,
            viewIndex: lastIndex,
            position: position,
            duration: duration
        )

        if position == .top {
            topNotification.append(item)
            if topNotification.count == 1 {
                item.isActive = true
            }
        } else {
            bottomNotification.append(item)
            if bottomNotification.count == 1 {
                item.isActive = true
            }
        }

    }

    func remove(id: UUID, position: NotificationPosition) {
        if position == .top {
            topNotification.removeAll { $0.id == id }
        }
        if position == .bottom {
            bottomNotification.removeAll { $0.id == id }
        }
    }

    func activateNext(position: NotificationPosition) {
        if position == .top {
            guard let next = topNotification.first else { return }
            next.isActive = true
        }
        if position == .bottom {
            guard let next = bottomNotification.first else { return }
            next.isActive = true
        }
    }

}
