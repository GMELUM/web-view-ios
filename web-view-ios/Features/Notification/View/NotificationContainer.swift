//
//  NotificationContainer.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 13.05.2025.
//

import Combine
import SwiftUI

struct NotificationContainer: View {

    @EnvironmentObject var services: Services

    @State private var notificationHeights: [UUID: CGFloat] = [:]

    @State private var expandedStates: [UUID: Bool] = [:]

    var body: some View {
        GeometryReader { geometry in

            let safeAreaTop =
                UIApplication.shared.connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0
            
            

            ZStack {

                VStack(spacing: 0) {
                    ForEach(
                        Array(
                            services.popup.topNotification.prefix(3)
                                .enumerated()
                        ),
                        id: \.element.id
                    ) { index, item in
                        NotificationView(
                            data: item,
                            isExpanded: Binding(
                                get: { expandedStates[item.id] ?? false },
                                set: { expandedStates[item.id] = $0 }
                            )
                        )
                        .scaleEffect(scale(for: index))
                        .offset(
                            y: -offsetY(
                                for: index,
                                in: services.popup.topNotification
                            )
                        )
                        .zIndex(item.viewIndex)
                    }
                }
                .padding(.top, safeAreaTop)
                .onPreferenceChange(NotificationHeightPreferenceKey.self) {
                    heights in
                    notificationHeights = heights
                }
                .animation(
                    .spring(),
                    value: services.popup.topNotification.map { $0.id }
                )

                Spacer()

                //                VStack(spacing: 0) {
                //                    ForEach(
                //                        Array(
                //                            services.popup.bottomNotification.prefix(3)
                //                                .enumerated()
                //                        ),
                //                        id: \.element.id
                //                    ) { index, item in
                //                        NotificationView(data: item)
                //                            .scaleEffect(scale(for: index))
                //                            .offset(y: -offsetY(for: index))
                //                            .zIndex(item.viewIndex)
                //                    }
                //                }
                //                .padding(.top, safeAreaTop)
                //                .animation(
                //                    .spring(),
                //                    value: services.popup.bottomNotification.map { $0.id }
                //                )

            }

        }
    }

    func scale(for index: Int) -> CGFloat {
        return 1.0 - CGFloat(index) * 0.05
    }

    func offsetY(for index: Int, in notifications: [NotificationData]) -> CGFloat {
        guard index > 0 else { return 0 }

        var offset: CGFloat = 0
        var afterExpanded: Bool = false
        for i in 0..<index {
            let id = notifications[i].id
            let height = services.popup.notificationHeights[id] ?? 70
            let isExpanded = expandedStates[id] ?? afterExpanded
            if isExpanded {
                afterExpanded = true
            }
            offset += height - (isExpanded ? 5 : 10)
        }

        return offset
    }

}
