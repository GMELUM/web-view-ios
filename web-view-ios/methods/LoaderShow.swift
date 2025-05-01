//
//  LoaderShow.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

// This file extends the functionality of the App class
// to incorporate methods specifically designed for managing the
// presentation of the loading screen, referred to as the "loader".
// By using an extension, we can effectively compartmentalize
// specific functionalities, leading to better organized and more
// manageable code.

// This extension is specifically for the App class,
// which manages the lifecycle of the application’s main interface
// that includes the web view and associated UI components, like
// the loader.
extension App {
    
    // The loaderShow() method is responsible for displaying the
    // loading screen (loaderApp). This function leverages the
    // show method defined on loaderApp, which handles adding
    // the loader UI to the current view hierarchy.

    // Displaying the loader is essential when the application is
    // preparing or loading content, such as when a web page begins
    // loading. It provides users with a visual indication that
    // a process is occurring, thereby improving user experience
    // by preventing any confusion during content preparation.
    
    // This method provides a centralized location to control the
    // display logic for the loader, facilitating easier maintenance
    // and enabling consistent behavior across various parts of the
    // app where the loader may be needed.
    func loaderShow(r: Int, e: String, d: Any) {
        // Invokes the show method on the loaderApp instance.
        // This call will likely encompass functionality to animate
        // the loader’s appearance and attach it to the main view
        // of the app, ensuring it is visible to the user.
        loaderApp.show(on: self.view)
        
        sendResponse(requestID: r, event: e, data: ["success": true])
    }
}
