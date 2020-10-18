//
//  CameraInput.swift
//  Identity Crisis
//
//  Created by Apollo Zhu on 10/17/20.
//

import Foundation
import Combine
import AVKit

class CameraInput: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var error: Error? = nil
    @Published var emotion: Emotion = .neutral

    // AVCapture variables to hold sequence data
    public private(set) lazy var session: AVCaptureSession? = {
        let captureSession = AVCaptureSession()
        do {
            let inputDevice = try configureFrontCamera(for: captureSession)
            configureVideoDataOutput(for: inputDevice.device,
                                     resolution: inputDevice.resolution,
                                     captureSession: captureSession)
            return captureSession
        } catch {
            setError("Failed to setup capture session:", error)
            return nil
        }
    }()
    private var videoDataOutput: AVCaptureVideoDataOutput?
    private var videoDataOutputQueue: DispatchQueue?
    private var captureDevice: AVCaptureDevice?
    private var captureDeviceResolution: CGSize = .zero

    // Vision requests
    //    private var trackingRequests: [VNTrackObjectRequest]?
    //    private lazy var sequenceRequestHandler = VNSequenceRequestHandler()

    public func start() {
        session?.startRunning()
    }

    public func stop() {
        session?.stopRunning()
    }

    deinit { stop() }

    private func highestResolutionFormat(for device: AVCaptureDevice) -> (format: AVCaptureDevice.Format, resolution: CGSize)? {
        var highestResolutionFormat: AVCaptureDevice.Format? = nil
        var highestResolutionDimensions = CMVideoDimensions(width: 0, height: 0)

        for format in device.formats {
            let deviceFormat = format as AVCaptureDevice.Format
            let deviceFormatDescription = deviceFormat.formatDescription
            let candidateDimensions = CMVideoFormatDescriptionGetDimensions(deviceFormatDescription)
            if highestResolutionFormat == nil
                || candidateDimensions.width > highestResolutionDimensions.width {
                highestResolutionFormat = deviceFormat
                highestResolutionDimensions = candidateDimensions
            }
        }

        return highestResolutionFormat.map {
            let resolution = CGSize(width: CGFloat(highestResolutionDimensions.width),
                                    height: CGFloat(highestResolutionDimensions.height))
            return ($0, resolution)
        }
    }

    fileprivate func configureFrontCamera(for captureSession: AVCaptureSession) throws -> (device: AVCaptureDevice, resolution: CGSize) {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)

        guard let device = deviceDiscoverySession.devices.first else {
            throw NSError(domain: #file, code: 1, userInfo: nil)
        }
        let deviceInput = try AVCaptureDeviceInput(device: device)
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        guard let highestResolution = highestResolutionFormat(for: device) else {
            throw NSError(domain: #file, code: 2, userInfo: nil)
        }
        try device.lockForConfiguration()
        device.activeFormat = highestResolution.format
        device.unlockForConfiguration()

        return (device, highestResolution.resolution)
    }

    /// - Tag: CreateSerialDispatchQueue
    fileprivate func configureVideoDataOutput(for inputDevice: AVCaptureDevice, resolution: CGSize, captureSession: AVCaptureSession) {

        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.alwaysDiscardsLateVideoFrames = true

        // Create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured.
        // A serial dispatch queue must be used to guarantee that video frames will be delivered in order.
        let videoDataOutputQueue = DispatchQueue(label: "io.github.uwdevapp.Identity-Crisis.VisionFaceTrack")
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)

        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }

        videoDataOutput.connection(with: .video)?.isEnabled = true

        captureDevice = inputDevice
        captureDeviceResolution = resolution
    }

    // Removes infrastructure for AVCapture as part of cleanup.
    fileprivate func teardownAVCapture() {
        videoDataOutput = nil
        videoDataOutputQueue = nil
    }

    // MARK: Helper Methods for Handling Device Orientation & EXIF

    fileprivate func radiansForDegrees(_ degrees: CGFloat) -> CGFloat {
        return CGFloat(Double(degrees) * .pi / 180.0)
    }

    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    // Handle delegate method callback on receiving a sample buffer.
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to obtain a CVPixelBuffer for the current output frame.")
            return
        }

        let cameraIntrinsics = CMGetAttachment(
            sampleBuffer,
            key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix,
            attachmentModeOut: nil
        )
        EmotionClassification
            .auto
            .classify(
                image: pixelBuffer,
                size: captureDeviceResolution,
                cameraIntrinsicData: cameraIntrinsics
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let emotion):
                        self.emotion = emotion
                    case .failure(let error):
                        self.setError("Failed to perform classification:", error)
                    }
                }
            }

        // guard let requests = trackingRequests, !requests.isEmpty else {
        //     // No tracking object detected, so perform initial detection
        //
        //     return
        // }

        // do {
        //     try sequenceRequestHandler.perform(requests, on: pixelBuffer)
        // } catch {
        //     setError("Failed to perform SequenceRequest:", error)
        // }
        //
        // // Setup the next round of tracking.
        // var newTrackingRequests = [VNTrackObjectRequest]()
        // for trackingRequest in requests {
        //     guard let results = trackingRequest.results else {
        //         return
        //     }
        //
        //     guard let observation = results[0] as? VNDetectedObjectObservation else {
        //         return
        //     }
        //
        //     if !trackingRequest.isLastFrame {
        //         if observation.confidence > 0.3 {
        //             trackingRequest.inputObservation = observation
        //         } else {
        //             trackingRequest.isLastFrame = true
        //         }
        //         newTrackingRequests.append(trackingRequest)
        //     }
        // }
        // trackingRequests = newTrackingRequests
    }

    private func setError(_ reason: String, _ error: Error) {
        print(reason, error)
        DispatchQueue.main.async {
            self.error = error
        }
    }
}
