import AVFoundation
import AudioToolbox
import UIKit

class ModalViewController: UIViewController, ManagedModal,
    AVCaptureMetadataOutputObjectsDelegate,
    UIAdaptivePresentationControllerDelegate
{

    private var manager: ModalManager?
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var metadataOutput: AVCaptureMetadataOutput!
    private var scanAreaFrame: CGRect = .zero
    private var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCamera()
        setupScanOverlay()
        self.presentationController?.delegate = self
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Header view
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
        ])

        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.tintColor = .systemBlue // Используем акцентный цвет
        closeButton.addTarget(
            self,
            action: #selector(closeAndSendData),
            for: .touchUpInside
        )
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20), // Перемещаем кнопку налево
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "Scan QR Code"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor), // Центрируем заголовок
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        // Container view for preview and overlay
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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

        metadataOutput = AVCaptureMetadataOutput()
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
        // Use containerView.bounds instead of view.bounds
        previewLayer.frame = containerView.bounds
        containerView.layer.addSublayer(previewLayer)
    }

    private func setupScanOverlay() {
        let overlay = ScanOverlayView(cutoutSize: 250) { cutoutRect in
            self.scanAreaFrame = cutoutRect
            let convertedRect = self.previewLayer.metadataOutputRectConverted(
                fromLayerRect: cutoutRect
            )
            self.metadataOutput.rectOfInterest = convertedRect
        }
        overlay.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(overlay)

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: containerView.topAnchor),
            overlay.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor
            ),
            overlay.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor
            ),
            overlay.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor
            ),
        ])
        
        let instructionLabel = UILabel()
        instructionLabel.text = "Align QR code within frame to scan"
        instructionLabel.textColor = .tertiaryLabel
        instructionLabel.textAlignment = .center
        instructionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(instructionLabel)

        // Position the label centered above the scan area
        NSLayoutConstraint.activate([
            instructionLabel.bottomAnchor.constraint(equalTo: overlay.centerYAnchor, constant: -200), // Adjust for proper position
            instructionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = containerView.bounds
    }

    func configure(with manager: ModalManager) {
        self.manager = manager
    }

    @objc private func closeAndSendData() {
        manager?.close(modal: self, withData: "")
        captureSession.stopRunning()
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

class ScanOverlayView: UIView {

    private let cutoutSize: CGFloat
    private let cornerRadius: CGFloat = 20
    private let cornerLength: CGFloat = 20
    private var onFrameCalculated: ((CGRect) -> Void)?

    init(cutoutSize: CGFloat, onFrameCalculated: ((CGRect) -> Void)? = nil) {
        self.cutoutSize = cutoutSize
        self.onFrameCalculated = onFrameCalculated
        super.init(frame: .zero)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(UIColor.black.withAlphaComponent(0.5).cgColor)
        context.fill(bounds)

        let scanRect = CGRect(
            x: (bounds.width - cutoutSize) / 2,
            y: (bounds.height - cutoutSize) / 2,
            width: cutoutSize,
            height: cutoutSize
        )

        onFrameCalculated?(scanRect)

        let cutoutPath = UIBezierPath(
            roundedRect: scanRect,
            cornerRadius: cornerRadius
        )
        context.setBlendMode(.clear)
        UIColor.clear.setFill()
        cutoutPath.fill()

        context.setBlendMode(.normal)
        context.setStrokeColor(UIColor.systemBlue.cgColor)
        context.setLineWidth(4)
        drawCorners(in: context, rect: scanRect)
    }

    private func drawCorners(in context: CGContext, rect: CGRect) {
        let r = cornerRadius
        let l = cornerLength

        let tl = CGPoint(x: rect.minX, y: rect.minY)
        let tr = CGPoint(x: rect.maxX, y: rect.minY)
        let bl = CGPoint(x: rect.minX, y: rect.maxY)
        let br = CGPoint(x: rect.maxX, y: rect.maxY)

        context.move(to: CGPoint(x: tl.x, y: tl.y + l))
        context.addLine(to: CGPoint(x: tl.x, y: tl.y + r))
        context.addArc(
            center: CGPoint(x: tl.x + r, y: tl.y + r),
            radius: r,
            startAngle: .pi,
            endAngle: -.pi / 2,
            clockwise: false
        )
        context.addLine(to: CGPoint(x: tl.x + l, y: tl.y))

        context.move(to: CGPoint(x: tr.x - l, y: tr.y))
        context.addLine(to: CGPoint(x: tr.x - r, y: tr.y))
        context.addArc(
            center: CGPoint(x: tr.x - r, y: tr.y + r),
            radius: r,
            startAngle: -.pi / 2,
            endAngle: 0,
            clockwise: false
        )
        context.addLine(to: CGPoint(x: tr.x, y: tr.y + l))

        context.move(to: CGPoint(x: bl.x, y: bl.y - l))
        context.addLine(to: CGPoint(x: bl.x, y: bl.y - r))
        context.addArc(
            center: CGPoint(x: bl.x + r, y: bl.y - r),
            radius: r,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: true
        )
        context.addLine(to: CGPoint(x: bl.x + l, y: bl.y))

        context.move(to: CGPoint(x: br.x - l, y: br.y))
        context.addLine(to: CGPoint(x: br.x - r, y: br.y))
        context.addArc(
            center: CGPoint(x: br.x - r, y: br.y - r),
            radius: r,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: true
        )
        context.addLine(to: CGPoint(x: br.x, y: br.y - l))

        context.strokePath()
    }

}
