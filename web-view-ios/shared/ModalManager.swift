//
//  ModalManager.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

// Protocol to define a modal view controller with configuration capabilities.
// Conforms to `UIViewController` and `UIAdaptivePresentationControllerDelegate`.
protocol ManagedModal: UIViewController, UIAdaptivePresentationControllerDelegate {
    // Configure the modal with a given `ModalManager`.
    // - Parameter manager: The manager instance to be associated with the modal.
    func configure(with manager: ModalManager)
}

// A class for managing the presentation and dismissal of modal view controllers.
class ModalManager {
    
    // State indicating if a modal is currently presented.
    private var isModalPresented = false
    
    // Closure to handle completion logic after the modal is dismissed with optional data.
    private var completion: ((Any?) -> Void)?
    
    // Presents a modal view controller from a given presenting view controller.
    // - Parameters:
    //   - modal: The modal view controller conforming to ManagedModal protocol.
    //   - presentingViewController: The view controller from which the modal will be presented.
    //   - completion: A closure to be executed after the modal is closed, with optional data.
    func open(modal: ManagedModal, from presentingViewController: UIViewController, completion: @escaping (Any?) -> Void) {
        // Ensure no modal is currently being presented before continuing.
        guard !isModalPresented else { return }
        
        // Store the completion closure for later use when the modal is dismissed.
        self.completion = completion
        
        // Configure the modal using the manager instance.
        modal.configure(with: self)
        
        // Present the modal view controller with animation.
        presentingViewController.present(modal, animated: true) {
            // Update the state to reflect that a modal is presented.
            self.isModalPresented = true
        }
    }
    
    // Dismisses the currently presented modal view controller.
    // - Parameters:
    //   - modal: The modal to be dismissed.
    //   - data: Optional data to be passed to the completion closure.
    func close(modal: ManagedModal, withData data: Any?) {
        // Dismiss the modal view controller with animation.
        modal.dismiss(animated: true) {
            // Execute the completion closure with optional data provided.
            self.completion?(data)
            
            // Update the state as no modal is being presented after dismissal.
            self.isModalPresented = false
            
            // Clear the completion closure to release references and free associated memory.
            self.completion = nil
        }
    }
}
