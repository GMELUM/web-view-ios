//
//  Notification.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 13.05.2025.
//

import SwiftUI

struct NotificationHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGFloat] = [:]

    static func reduce(
        value: inout [UUID: CGFloat],
        nextValue: () -> [UUID: CGFloat]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct AnyNotificationExpandedPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

struct NotificationView: View {

    @ObservedObject var data: NotificationData
    @EnvironmentObject var services: Services
    
    @Binding var isExpanded: Bool

    @State private var timerStarted = false
    @State private var timerWorkItem: DispatchWorkItem?
    @State private var animateOffset = true
    @State private var isBeingDismissed = false

    private var offsetX: CGFloat {
        switch data.dragDirection {
        case .left, .right: return data.dragOffset.width
        default: return 0
        }
    }

    private var offsetY: CGFloat {
        switch data.dragDirection {
        case .up, .down: return data.dragOffset.height
        default: return 0
        }
    }

    private var removalTransition: AnyTransition {
        switch data.dragDirection {
        case .left: return .move(edge: .leading).combined(with: .opacity)
        case .right: return .move(edge: .trailing).combined(with: .opacity)
        case .up: return .move(edge: .top).combined(with: .opacity)
        case .down: return .move(edge: .bottom).combined(with: .opacity)
        default: return .move(edge: .top).combined(with: .opacity)
        }
    }

    var body: some View {
        content
            .offset(x: offsetX, y: offsetY)
            .animation(
                animateOffset && !isBeingDismissed ? .spring() : nil,
                value: data.dragOffset
            )
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 1)
                        .combined(with: .move(edge: .top))
                        .combined(with: .opacity),
                    removal: removalTransition
                )
            )
            .gesture(dragGesture)
            .onAppear {
                startIfNeeded()
            }
            .onChange(of: data.isActive) { if $0 { startIfNeeded() } }
            .onChange(of: isExpanded) { expanded in
                if expanded {
                    cancelTimer()
                } else if data.isActive {
                    resumeTimer()
                }
            }
    }

    private var content: some View {
        HStack(alignment: .top, spacing: 12) {
            
            Base64ImageView(base64: data.icon)
                .alignmentGuide(.top) { d in d[.top] }

            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(data.title))
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color(.label))
                    .lineLimit(isExpanded ? nil : 1)
                    .animation(.easeInOut, value: isExpanded)

                Text(LocalizedStringKey(data.message))
                    .font(.subheadline)
                    .foregroundColor(Color(.label))
                    .lineLimit(isExpanded ? nil : 1)
                    .animation(.easeInOut, value: isExpanded)
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(16)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: NotificationHeightPreferenceKey.self,
                        value: [data.id: proxy.size.height]
                    )
            }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            guard data.isActive else { return }
            withAnimation(.easeInOut) {
                isExpanded.toggle()
            }
        }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard data.isActive else { return }
                cancelTimer()
                animateOffset = false

                let translation = value.translation
                if data.dragDirection == .none {
                    if abs(translation.width) > 20 {
                        data.dragDirection = translation.width > 0 ? .right : .left
                    } else if abs(translation.height) > 20 {
                        if translation.height > 0 {
                            if data.position != .top {
                                data.dragDirection = .down
                            }
                        } else {
                            if data.position != .bottom {
                                data.dragDirection = .up
                            }
                        }
                    }
                }

                switch data.dragDirection {
                case .left, .right:
                    data.dragOffset = CGSize(
                        width: translation.width,
                        height: 0
                    )
                case .up, .down:
                    data.dragOffset = CGSize(
                        width: 0,
                        height: translation.height
                    )
                default: break
                }
            }
            .onEnded { value in
                guard data.isActive else { return }
                animateOffset = true
                
                if data.dragDirection == .up && value.translation.height < -50
                    || data.dragDirection == .down && value.translation.height > 50
                    || abs(value.translation.width) > 100 {
                    
                    withAnimation {
                        data.dragOffset = dismissOffset(for: data.dragDirection)
                        services.popup.remove(id: data.id, position: data.position)
                        services.popup.activateNext(position: data.position)
                    }

                } else {
                    withAnimation {
                        data.dragOffset = .zero
                        data.dragDirection = .none
                    }
                    resumeTimer()
                }
            }
    }

    private func dismissOffset(for direction: DragDirection) -> CGSize {
        switch direction {
        case .left: return CGSize(width: -400, height: 0)
        case .right: return CGSize(width: 800, height: 0)
        case .up: return CGSize(width: 0, height: -400)
        case .down: return CGSize(width: 0, height: 400)
        default: return .zero
        }
    }

    private func startIfNeeded() {
        guard data.isActive, !timerStarted, !isExpanded else { return }
        timerStarted = true

        let workItem = DispatchWorkItem {
            withAnimation {
                timerStarted = false
                services.popup.remove(
                    id: data.id,
                    position: data.position
                )
                services.popup.activateNext(position: data.position)
            }
        }

        timerWorkItem = workItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + data.duration,
            execute: workItem
        )
    }

    private func resumeTimer() {
        guard timerStarted == false, timerWorkItem == nil, !isExpanded else {
            return
        }
        startIfNeeded()
    }
    
    private func cancelTimer() {
        timerWorkItem?.cancel()
        timerWorkItem = nil
        timerStarted = false
    }

}
