//
//  CameraScanController.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

import AVFoundation
import AudioToolbox
import UIKit

class CameraScanController: UIViewController,
    AVCaptureMetadataOutputObjectsDelegate
{
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var onCodeScanned: ((String) -> Void)?
    var onScanAreaDefined: ((CGRect) -> Void)?
    var scanAreaSize: CGFloat = 250

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCamera()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        DispatchQueue.main.async {
            self.defineScanArea()
        }
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video)
        else {
            showFailureAlert()
            return
        }

        do {
            let videoInput = try AVCaptureDeviceInput(
                device: videoCaptureDevice
            )
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                showFailureAlert()
                return
            }
        } catch {
            showFailureAlert()
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
            showFailureAlert()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    private func defineScanArea() {
        let width = view.bounds.width
        let height = view.bounds.height
        let cutoutRect = CGRect(
            x: (width - scanAreaSize) / 2,
            y: (height - scanAreaSize) / 2,
            width: scanAreaSize,
            height: scanAreaSize
        )

        if let metadataOutput = captureSession.outputs.compactMap({
            $0 as? AVCaptureMetadataOutput
        }).first {
            let convertedRect = previewLayer.metadataOutputRectConverted(
                fromLayerRect: cutoutRect
            )
            metadataOutput.rectOfInterest = convertedRect
        }

        onScanAreaDefined?(cutoutRect)
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first,
            let readableObject = metadataObject
                as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue
        {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            onCodeScanned?(stringValue)
        }
    }

    private func showFailureAlert() {
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
}
