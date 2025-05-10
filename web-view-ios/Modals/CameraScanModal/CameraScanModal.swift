import AVFoundation
import AudioToolbox
import SwiftUI



struct CameraScanModal: View {

    var modalID: String = "cameraScanModal"

    @EnvironmentObject var services: Services
    @Environment(\.presentationMode) var presentationMode
    @State private var scanAreaFrame: CGRect = .zero
    @State private var scannedCode: String? = nil  // State to hold the result
    private let scanAreaSize: CGFloat = 250

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Close") {
                    scannedCode = nil  // Reset or define it with the needed value
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)

                Spacer()

                Text("Scan QR Code")
                    .font(.headline)

                Spacer()
                Spacer().frame(width: 30)
            }
            .padding()
            .background(Color(UIColor.systemBackground))

            ZStack {
                CameraView(
                    onCodeScanned: { code in
                        scannedCode = code  // Set result
                        presentationMode.wrappedValue.dismiss()
                    },
                    onScanAreaDefined: { frame in
                        scanAreaFrame = frame
                    },
                    scanAreaSize: scanAreaSize
                )
                .edgesIgnoringSafeArea(.all)

                CameraScanOverlay(cutoutSize: scanAreaSize)

                VStack {
                    Text("Align QR code within frame to scan")
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)
                    Spacer()
                }
                .padding(.top, 100)
            }
        }
        .background(Color(UIColor.systemBackground))
        .onDisappear {
            services.modal.close(with: scannedCode)
        }
    }

    struct CameraView: UIViewControllerRepresentable {
        var onCodeScanned: (String) -> Void
        var onScanAreaDefined: (CGRect) -> Void
        var scanAreaSize: CGFloat

        func makeUIViewController(context: Context) -> CameraScanController {
            let controller = CameraScanController()
            controller.onCodeScanned = onCodeScanned
            controller.onScanAreaDefined = onScanAreaDefined
            controller.scanAreaSize = scanAreaSize
            return controller
        }

        func updateUIViewController(
            _ uiViewController: CameraScanController,
            context: Context
        ) {}
    }
}
