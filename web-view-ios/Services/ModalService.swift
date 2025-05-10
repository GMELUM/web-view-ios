//
//  ModalService.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

import Combine
import SwiftUI

final class ModalService: ObservableObject {

    struct ModalData: Identifiable {
        let id = UUID()
        let view: AnyView
    }

    @Published var currentModal: ModalData?

    private var onHandler: ((Any?) -> Void)?

    func open<Content: View>(
        _ view: Content,
        onHandler: ((Any?) -> Void)? = nil
    ) {
        currentModal = ModalData(view: AnyView(view))
        self.onHandler = onHandler
    }

    func close(with data: Any? = nil) {
        onHandler?(data)
        currentModal = nil
        
    }

}
