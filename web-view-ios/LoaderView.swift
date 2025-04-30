//
//  LoaderView.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 01.05.2025.
//

import UIKit

// The LoaderView class is a custom UIView subclass designed to
// display a loading screen or "loader" within an application.
// This class encapsulates the setup and display logic for the
// loader, providing a consistent and reusable component.

// This class maintains two image views: one for the logo and one
// for the branding icon, both of which are intended to provide
// visual feedback during loading phases and ensure cohesive
// branding presence.

class LoaderView: UIView {

    // Private properties for the logo and brand image views.
    // These are initialized during object creation and used
    // to display images centered on the loader view.
    private let logoImageView: UIImageView
    private let brandImageView: UIImageView

    // Initializer method for programmatic view creation.
    // It initializes the image views with templates, ensuring
    // that the tint color can be applied dynamically to match
    // the current UI theme or style automatically.
    override init(frame: CGRect) {
        // Initialize logoImageView with the "LogoLoader" image
        // and set it to always use the template rendering mode,
        // which allows tinting based on the app's theme.
        self.logoImageView = UIImageView(
            image: UIImage(named: "LogoLoader")?.withRenderingMode(
                .alwaysTemplate
            )
        )
        
        // Initialize brandImageView with the "BrandIcons" image
        // and similarly use the template mode for tinting.
        self.brandImageView = UIImageView(
            image: UIImage(named: "BrandIcons")?.withRenderingMode(
                .alwaysTemplate
            )
        )

        // Call the superclass's designated initializer to
        // complete the initialization process.
        super.init(frame: frame)

        // Call a helper function to set up the view's appearance
        // and layout constraints, required for proper rendering.
        setupView()
    }

    // Required initializer for cases where the view is loaded
    // from storyboard or xib files, which are not used here.
    // This implementation will throw a runtime error if called,
    // indicating this view is intended for programmatic creation.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Private method to configure the appearance and layout
    // constraints for the loader's subviews.
    private func setupView() {
        // Set the background color to systemBackground, ensuring
        // it adapts to light or dark mode dynamically.
        self.backgroundColor = .systemBackground

        // Configure the logoImageView's appearance and add it
        // to the view hierarchy with its layout constraints.
        logoImageView.tintColor = .label  // Set to match system label color
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)

        // Configure the brandImageView's appearance and add it
        // to the view hierarchy with its layout constraints.
        brandImageView.tintColor = .label
        brandImageView.contentMode = .scaleAspectFit
        brandImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(brandImageView)

        // Activate layout constraints to ensure both image views
        // are centered and positioned as expected within the view.
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(
                equalTo: self.centerXAnchor
            ),
            logoImageView.centerYAnchor.constraint(
                equalTo: self.centerYAnchor
            ),
            brandImageView.centerXAnchor.constraint(
                equalTo: self.centerXAnchor
            ),
            brandImageView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: -32
            ),
        ])
    }

    // Public method to show the loader by adding it to a specified
    // parent view and making it fully opaque, indicating an ongoing
    // operation such as loading content.
    func show(on parentView: UIView) {
        self.alpha = 1  // Ensure the loader is fully visible
        parentView.addSubview(self)  // Add to the parent view
    }

    // Public method to hide the loader using an animation, which
    // gradually fades the loader out before removing it from the
    // superview to free up memory and resources.
    func hide() {
        UIView.animate(withDuration: 0.5) {  // Animate over half a second
            self.alpha = 0  // Fade out to invisible
        } completion: { _ in
            self.removeFromSuperview()  // Remove after animation completes
        }
    }
}
