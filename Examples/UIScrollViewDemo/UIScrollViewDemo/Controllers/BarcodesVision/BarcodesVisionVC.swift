/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Vision
import AVFoundation
import SafariServices

// https://www.raywenderlich.com/12663654-vision-framework-tutorial-for-ios-scanning-barcodes

class BarcodesVisionVC: UIViewController {
    // MARK: - Private Variables
    var captureSession = AVCaptureSession()
    
    // TODO: Make VNDetectBarcodesRequest variable
    lazy var detectBarcodeRequest = VNDetectBarcodesRequest { request, error in
        guard error == nil else {
            self.showAlert(withTitle: "Barcode error", message: error?.localizedDescription ?? "error")
            return
        }
        self.processClassification(request)
    }
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissions()
        setupCameraLiveView()
        
        view.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: Stop Session
        captureSession.stopRunning()
    }
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
}


extension BarcodesVisionVC {
    // MARK: - Camera
    private func checkPermissions() {
        // TODO: Checking permissions
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [self] granted in
                if !granted {
                    self.showPermissionsAlert()
                }
            }
        case .denied, .restricted:
            showPermissionsAlert()
        default:
            return
        }
    }
    
    private func setupCameraLiveView() {
        // TODO: Setup captureSession
        captureSession.sessionPreset = .hd1280x720
        
        // TODO: Add input
        let videoDevice = AVCaptureDevice
            .default(.builtInWideAngleCamera, for: .video, position: .back)
        
        guard
            let device = videoDevice,
            let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(videoDeviceInput) else {
            showAlert(
                withTitle: "Cannot Find Camera",
                message: "There seems to be a problem with the camera on your device.")
            return
        }
        
        captureSession.addInput(videoDeviceInput)
        
        // TODO: Add output
        let captureOutput = AVCaptureVideoDataOutput()
        // TODO: Set video sample rate
        captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        captureSession.addOutput(captureOutput)
        
        configurePreviewLayer()
        
        // TODO: Run session
        captureSession.startRunning()
    }
    
    // MARK: - Vision
    func processClassification(_ request: VNRequest) {
        // TODO: Main logic
        guard let barcodes = request.results else { return }
        DispatchQueue.main.async { [self] in
            if captureSession.isRunning {
                view.layer.sublayers?.removeSubrange(1...)
                
                for barcode in barcodes {
                    guard
                        // TODO: Check for QR Code symbology and confidence score
                        let potentialQRCode = barcode as? VNBarcodeObservation,
                        potentialQRCode.symbology == .QR,
                        potentialQRCode.confidence > 0.9
                    else { return }
                    
                    // https://github.com/jeffreybergier/Blog-Getting-Started-with-Vision/issues/2
                    
                    let t = CGAffineTransform(translationX: 0.5, y: 0.5)
                        .rotated(by: CGFloat.pi / 2)
                        .translatedBy(x: -0.5, y: -0.5)
                        .translatedBy(x: 1.0, y: 0)
                        .scaledBy(x: -1, y: 1)
                    let box = potentialQRCode.boundingBox.applying(t)
                    
                    let convertedRect = self.cameraPreviewLayer.layerRectConverted(
                        fromMetadataOutputRect: box
                    )
                    
                    UIUtilities.addRectangle(
                        convertedRect,
                        to: view,
                        text: potentialQRCode.payloadStringValue
                    )
                    
                    
                    //          observationHandler(payload: potentialQRCode.payloadStringValue)
                }
                //          captureSession.stopRunning()
            }
        }
    }
    
    // MARK: - Handler
    func observationHandler(payload: String?) {
        // TODO: Open it in Safari
        guard
            let payloadString = payload,
            let url = URL(string: payloadString),
            ["http", "https"].contains(url.scheme?.lowercased())
        else { return }
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let safariVC = SFSafariViewController(url: url, configuration: config)
        safariVC.delegate = self
        present(safariVC, animated: true)
    }
}


// MARK: - AVCaptureDelegation
extension BarcodesVisionVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // TODO: Live Vision
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let imageRequestHandler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: .right)
        
        do {
            try imageRequestHandler.perform([detectBarcodeRequest])
        } catch {
            print(error)
        }
    }
}


// MARK: - Helper
extension BarcodesVisionVC {
    
    private func configurePreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer = cameraPreviewLayer
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = view.frame
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    private func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    private func showPermissionsAlert() {
        showAlert(
            withTitle: "Camera Permissions",
            message: "Please open Settings and grant permission for this app to use your camera.")
    }
}


// MARK: - SafariViewControllerDelegate
extension BarcodesVisionVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        captureSession.startRunning()
    }
}
