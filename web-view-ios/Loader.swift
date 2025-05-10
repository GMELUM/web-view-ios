import SwiftUI

// The Loader struct defines a SwiftUI view designed to
// display a loading indicator within an application.
// This component is intended to be shown or hidden based
// on the value of a binding, providing a flexible and
// reactive way to manage loading states.

// The view consists of two images: one representing a
// logo and another a branding icon, both aligning with
// the center vertically and horizontally, to provide
// consistent feedback during loading operations.

struct Loader: View {

    // A binding variable to control the visibility of the loader.
    // The loader is displayed whenever isVisible is true and
    // hidden otherwise, enabling it to react dynamically to state changes.
    @Binding var isVisible: Bool

    var body: some View {
        ZStack {
            // Background color applied to the entire ZStack
            Color(.systemBackground)
            /*.edgesIgnoringSafeArea(.all)*/ // Cover all screen space

            // Conditionally display the content when the loader is visible.
            VStack {
                // Inserted for distributing space around the images.
                Spacer()

                // The logo image, rendered with a template mode to allow
                // dynamic color adjustments in accordance with the current UI theme.
                Image("LogoLoader")
                    // Enables the image to resize to fit the given frame.
                    .resizable()
                    // Maintains the aspect ratio while fitting within the frame.
                    .scaledToFit()
                    // Applies the system label color as tint.
                    .foregroundColor(Color(.label))
                    // Maintains the original aspect ratio while fitting within the container.
                    .aspectRatio(contentMode: .fit)
                    // Sets explicit dimensions for the logo.
                    .frame(width: 74, height: 74)
                    // Adds a top padding for spacing.
                    .padding(.top, 33)

                // Additional spacer for even distribution of elements.
                Spacer()

                // The brand icon, following similar theming and alignment principles.
                Image("BrandIcons")
                    // Enables the image to resize to fit the given frame.
                    .resizable()
                    // Maintains the aspect ratio while fitting within the frame.
                    .scaledToFit()
                    // Applies the system label color as tint.
                    .foregroundColor(Color(.label))
                    // Maintains the original aspect ratio while fitting within the container.
                    .aspectRatio(contentMode: .fit)
                    // Sets explicit dimensions for the icon.
                    .frame(width: 90, height: 30)
                    // Bottom padding to offset from the view's edge.
                    .padding(.bottom, 32)
            }
            .padding(
                .bottom,
                UIApplication
                    .shared
                    .connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }?.safeAreaInsets.bottom
            )
            .padding(
                .top,
                UIApplication
                    .shared
                    .connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }?.safeAreaInsets.top
            )
        }
        // Ensure both the background and contents transition together.
        // Control visibility with opacity
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.5), value: isVisible)
    }
}

// PreviewProvider for Loader
// This struct facilitates a preview in Xcode Canvas, allowing
// developers to visualize the Loader component in different states.
struct Loader_Previews: PreviewProvider {
    // Static state used to manipulate the visibility of the Loader
    @State static var isVisible = true

    // Provides a preview of the Loader with a dynamically bound visibility
    static var previews: some View {
        Loader(isVisible: $isVisible)
            // Adjusts the preview to fit the size of its content
            .previewLayout(.sizeThatFits)
            // Allows testing the component in dark color scheme
            .preferredColorScheme(.dark)
    }
}
