//
//  ScreenService.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 10.05.2025.
//

import SwiftUI

final class ScreenService: ObservableObject {

    // Enable the screen to stay awake by disabling the idle timer.
    func enableScreenAlwaysOn() {
        UIApplication.shared.isIdleTimerDisabled = true
    }

    // Allow the screen to dim and lock based on system settings by enabling the idle timer.
    func disableScreenAlwaysOn() {
        UIApplication.shared.isIdleTimerDisabled = false
    }

}
