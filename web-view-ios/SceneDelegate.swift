//
//  SceneDelegate.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

// The SceneDelegate class is a part of the iOS app lifecycle management,
// introduced in iOS 13. It complements the AppDelegate and responds to
// lifecycle events specific to individual scenes, which represent instances
// of the app's UI.

// The class conforms to UIWindowSceneDelegate, which provides methods
// that manage scene-level state transitions and handle scene lifecycle events.

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // The 'window' property provides a reference to the UIWindow object
    // that manages and coordinates the views appearing on the screen.
    // It's the root of the app's view hierarchy for a scene.
    var window: UIWindow?

    // The scene(_:willConnectTo:options:) method is called when a scene
    // is being created and connected to the app session. It's used to set up
    // the window and make the scene visible.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure the provided scene can be cast to a UIWindowScene,
        // which represents the interactive scene managed by UIKit.
        guard let scene = (scene as? UIWindowScene) else { return }

        // Create a new UIWindow instance with the given UIWindowScene instance,
        // setting it as the main point for displaying views.
        self.window = UIWindow(windowScene: scene)

        // Set the rootViewController for the window, which is the initial view
        // controller that gets displayed when the app starts.
        self.window?.rootViewController = App()

        // Make the window key and visible, ensuring it becomes the foremost
        // window, capable of receiving touch events and updating the display.
        self.window?.makeKeyAndVisible()
    }

    // The sceneDidDisconnect(:) method is called when the scene is being
    // released by the system. It occurs shortly after entering the background
    // or when the session is discarded. Use this to release any resources
    // specific to this scene that can be re-created if the scene connects again.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Code here to handle when the scene disconnects.
    }

    // The sceneDidBecomeActive(:) method is called when the scene moves
    // to the active state from an inactive state. This is a good place to
    // restart tasks that were paused when the scene was inactive.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Code here to handle the scene becoming active.
    }

    // The sceneWillResignActive(:) method is called when the scene moves
    // from an active state to an inactive state, which can happen due to
    // temporary interruptions like receiving a phone call.
    func sceneWillResignActive(_ scene: UIScene) {
        // Code here to handle the scene resigning active state.
    }

    // The sceneWillEnterForeground(:) method is called as the scene
    // transitions from the background to the foreground. Use this method
    // to undo changes made when entering the background.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Code here to handle the scene entering the foreground.
    }

    // The sceneDidEnterBackground(:) method is called when the scene
    // transitions from the foreground to the background. Use this method
    // to save data and release shared resources to restore the scene to
    // its current state later.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Code here to handle the scene entering the background.
    }
}
