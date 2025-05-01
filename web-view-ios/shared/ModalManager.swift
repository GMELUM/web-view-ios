//
//  ModalManager.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

/// Протокол для управления модальными окнами
protocol ManagedModal: UIViewController, UIAdaptivePresentationControllerDelegate {
    func configure(with manager: ModalManager)
}

/// Класс для управления модальными окнами
class ModalManager {
    
    private var isModalPresented = false
    private var completion: ((Any?) -> Void)?
    
    func open(modal: ManagedModal, from presentingViewController: UIViewController, completion: @escaping (Any?) -> Void) {
        guard !isModalPresented else { return }
        
        self.completion = completion
        modal.configure(with: self)
        presentingViewController.present(modal, animated: true) {
            self.isModalPresented = true
        }
    }
    
    func close(modal: ManagedModal, withData data: Any?) {
        modal.dismiss(animated: true) {
            self.completion?(data)
            self.isModalPresented = false
            self.completion = nil
        }
    }
}
