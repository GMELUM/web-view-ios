//
//  Services.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

import Combine
import SwiftUI

// The Services class is an ObservableObject that aggregates various
// service instances used throughout the application. It centralizes
// the management and observation of multiple services, allowing for
// a cohesive approach to handling events and state changes.

final class Services: ObservableObject {
    // Published properties representing individual service instances
    // These services are themselves ObservableObjects, enabling
    // SwiftUI views to react to any changes within the services.
    @Published var loader = LoaderService()
    @Published var taptic = TapticService()
    @Published var storage = StorageService()
    @Published var gyroscope = GyroscopeService()
    @Published var accelerometer = AccelerometerService()
    @Published var flash = FlashService()
    @Published var app = AppService()
    @Published var modal = ModalService()
    @Published var screen = ScreenService()

    // A set of cancellables to manage any Combine subscriptions
    // within Services, ensuring they are properly deallocated.
    private var cancellables = Set<AnyCancellable>()

    // Initializes the Services, setting up any necessary observation.
    init() {
        // Observe changes in the loader service and notify
        // SwiftUI that the Services object has changed,
        // causing views to refresh if necessary.
        loader.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        modal.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
    }
}
