import AVFoundation
import UIKit

class ModalViewController: UIViewController, ManagedModal,
    AVCaptureMetadataOutputObjectsDelegate
{

    private var manager: ModalManager?
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()

        self.presentationController?.delegate = self
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close with Data", for: .normal)
        closeButton.addTarget(
            self,
            action: #selector(closeAndSendData),
            for: .touchUpInside
        )
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -20
            ),
        ])
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video)
        else { return }

        do {
            let videoInput = try AVCaptureDeviceInput(
                device: videoCaptureDevice
            )
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                failed()
                return
            }
        } catch {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(
                self,
                queue: DispatchQueue.main
            )
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    func configure(with manager: ModalManager) {
        self.manager = manager
    }

    @objc private func closeAndSendData() {
        manager?.close(modal: self, withData: "")
    }
    
    func presentationControllerDidDismiss(
        _ presentationController: UIPresentationController
    ) {
        closeAndSendData()
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard
                let readableObject = metadataObject
                    as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue
            else { return }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

            DispatchQueue.global(qos: .userInitiated).async {
                self.found(code: stringValue)
            }
        }
    }

    private func found(code: String) {
        DispatchQueue.main.async {
            self.manager?.close(modal: self, withData: code)
        }
    }

    private func failed() {
        let ac = UIAlertController(
            title: "Scanning not supported",
            message:
                "Your device does not support scanning a code from an item. Please use a device with a camera.",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
