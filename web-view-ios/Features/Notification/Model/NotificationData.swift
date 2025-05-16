//
//  NotificationData.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 14.05.2025.
//

import SwiftUI

enum DragDirection {
    case none
    case left
    case right
    case up
    case down
}

final class NotificationData: ObservableObject, Identifiable {
    let id: UUID = UUID()

    @Published var icon: String?
    @Published var title: String
    @Published var message: String
    
    @Published var isActive: Bool = false
    
    @Published var dragOffset: CGSize = .zero
    @Published var dragDirection: DragDirection = .none
    
    let viewIndex: Double
    let position: NotificationPosition
    let duration: Double

    init(
        icon: String?,
        title: String,
        message: String,
        viewIndex: Double,
        position: NotificationPosition,
        duration: Double
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.viewIndex = viewIndex
        self.position = position
        self.duration = duration
    }
}
