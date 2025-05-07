//
//  LoaderHide.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

// This file extends the functionality of the App class
// to include methods specifically related to handling the loading
// screen or "loader". By using an extension, we can modularize the
// code, making it easier to maintain and expand functionality
// without modifying the main class implementation.

// The extension below is for the App class, which is
// presumably the main screen of the application that manages the
// web view and loading animations.
extension App {

    // The loaderHide() method is a function that encapsulates the
    // logic to hide the loading screen (loaderApp). This method
    // utilizes the hide function of loaderApp, which contains the UI
    // logic for removing the loader from view.

    // Hiding the loader is often necessary after the main content
    // (like a web page) has finished loading, providing a clean
    // transition from the loading screen to the content screen.
    // This method acts as a single point of control for hiding
    // the loader, making the codebase easier to manage and debug.
    func loaderHide(r: Int, e: String, d: Any) {
        // Calls the hide method on the loaderApp instance.
        // This method should perform tasks such as animations to
        // fade out the loader view before removing it from the
        // superview, ensuring a smooth transition for the user.
        loaderApp.hide()

        // Sends a response after hiding the loader. This response
        // includes a request ID (r), an event string (e), and data
        // (d) which includes a success indicator.
        // This is important for communicating the state transition
        // back to the webview or server.
        webView.sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
