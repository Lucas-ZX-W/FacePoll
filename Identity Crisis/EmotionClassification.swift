//
//  EmotionClassification.swift
//  Identity Crisis
//
//  Created by Apollo Zhu on 10/17/20.
//

import Foundation

extension String: LocalizedError { }

enum EmotionClassification {
    case auto
    @available(*, deprecated, message: "Consider using python instead")
    case coreML
    case python

    typealias ResultHandler = (Result<Emotion, Error>) -> ()

    func classify(image pixelBuffer: CVImageBuffer, size: CGSize,
                  cameraIntrinsicData: CFTypeRef? = nil,
                  handler process: @escaping ResultHandler) {
        switch self {
        case .auto:
            classifyUsingPythonAPI(image: pixelBuffer, size: size) {
                switch $0 {
                case .success(let emotion):
                    process(.success(emotion))
                case .failure:
                    classifyUsingCoreML(
                        image: pixelBuffer, size: size,
                        cameraIntrinsicData: cameraIntrinsicData,
                        handler: process
                    )
                }
            }
        case .coreML:
            classifyUsingCoreML(
                image: pixelBuffer, size: size,
                cameraIntrinsicData: cameraIntrinsicData,
                handler: process
            )
        case .python:
            classifyUsingPythonAPI(image: pixelBuffer, size: size,
                                   handler: process)
        }
    }
}

// MARK: - CoreML

import CoreML
import Vision
import opencv2

extension EmotionClassification {
    fileprivate func classifyUsingCoreML(image pixelBuffer: CVImageBuffer, size: CGSize,
                                         cameraIntrinsicData: CFTypeRef? = nil,
                                         handler process: @escaping ResultHandler) {
        print("WARNING: please consider using Python API before I fix this")
        var requestHandlerOptions: [VNImageOption: AnyObject] = [:]
        if cameraIntrinsicData != nil {
            requestHandlerOptions[.cameraIntrinsics] = cameraIntrinsicData
        }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                        // orientation: exifOrientation,
                                                        options: requestHandlerOptions)
        do {
            try imageRequestHandler.perform([VNDetectFaceRectanglesRequest { (request, error) in
                guard let faceDetectionRequest = request as? VNDetectFaceRectanglesRequest,
                      let results = faceDetectionRequest.results as? [VNFaceObservation] else {
                    return process(.failure(error ?? "faceDetection error"))
                }

                if let faceObservation = results.first {
                    let faceBounds = VNImageRectForNormalizedRect(
                        faceObservation.boundingBox,
                        Int(size.width), Int(size.height)
                    )
                    classify(image: pixelBuffer,
                             faceBounds: faceBounds,
                             completion: process)
                }

                // DispatchQueue.main.async { [weak self] in
                //     // Add the observations to the tracking list
                //     self?.trackingRequests = results.map { observation in
                //         VNTrackObjectRequest(detectedObjectObservation: observation)
                //     }
                // }
            }])
        } catch {
            process(.failure(error))
        }
    }

    private func crop(_ image: CVPixelBuffer, to rect: CGRect) -> NSImage {
        let ciImage = CIImage(cvPixelBuffer: image)
            .cropped(to: rect)
        // .cropped(to: CGRect(x: rect.minX - 100,
        //                     y: rect.minY - 250,
        //                     width: rect.width + 200,
        //                     height: rect.height + 400))
        let representation = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: representation.size)
        nsImage.addRepresentation(representation)
        return nsImage
    }

    private func convert(_ nsImage: NSImage) throws -> MLMultiArray {
        var mat = Mat(nsImage: nsImage)
        Imgproc.resize(src: mat, dst: mat, dsize: Size(width: 48, height: 48))
        Imgproc.cvtColor(src: mat, dst: mat, code: .COLOR_RGBA2GRAY)
        mat = mat.reshape(channels: 1)
        return try MLMultiArray(dataPointer: mat.dataPointer(),
                                shape: [1, 48, 48],
                                dataType: .float32, strides: [1, 48, 48],
                                deallocator: nil)
    }

    private func classify(image: CVImageBuffer, faceBounds: CGRect,
                          completion process: @escaping ResultHandler) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let model = try emotion_detector(configuration: MLModelConfiguration())
                let image = crop(image, to: faceBounds)
                let input = try convert(image)
                let emotion = try model.prediction(image: input).emotion
                let pointer = emotion.dataPointer.bindMemory(to: Float32.self, capacity: 7)
                let results = Array(UnsafeBufferPointer(start: pointer, count: 7))
                if results.first?.isNormal == true {
                    for emotion in results.enumerated().sorted(by: { $0.element > $1.element }) {
                        print("\(Emotion(rawValue: emotion.offset)!) \(emotion.element * 100)%")
                    }
                    print()
                }
                let filtered = results.enumerated()
                    .filter { $0.element.isNormal && $0.element > 0.3 }
                guard !filtered.isEmpty else {
                    //                     "no emotion detected"
                    return
                }
                process(.success(
                    filtered
                        .max { $0.element < $1.element }
                        .flatMap { Emotion(rawValue: $0.offset) }!
                ))
            } catch {
                process(.failure(error))
            }
        }
    }
}

// MARK: - Python

extension CIImage {
    var base64: String {
        let representation = NSBitmapImageRep(ciImage: self)
        let data = representation.representation(using: .png, properties: [:])
        return "data:image/png;base64,\(data!.base64EncodedString())"
    }
}

extension EmotionClassification {
    private struct Upload: Encodable {
        let img: [String]
    }

    private struct Download: Decodable {
        struct Instance: Codable {
            let dominant_emotion: String
            // struct Emotion: Codable {
            //     let angry: Double
            //     let disgust: Double
            //     let fear: Double
            //     let happy: Double
            //     let neutral: Double
            //     let sad: Double
            //     let surprise: Double
            // }
            // let emotion: Emotion
        }
        let instance_1: Instance
    }

    fileprivate func classifyUsingPythonAPI(image pixelBuffer: CVImageBuffer, size: CGSize,
                                            cameraIntrinsicData: CFTypeRef? = nil,
                                            handler process: @escaping ResultHandler) {
        var request = URLRequest(url: URL(string: "http://0.0.0.0:5000/analyze")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let json = Upload(img: [CIImage(cvPixelBuffer: pixelBuffer).base64])
            let data = try JSONEncoder().encode(json)
            URLSession.shared.uploadTask(with: request, from: data) { (data, res, error) in
                process(Result {
                    guard let response = res as? HTTPURLResponse else {
                        throw error ?? "no response"
                    }
                    guard let data = data, response.statusCode == 200 else {
                        throw error ?? HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    }
                    let result = try JSONDecoder().decode(Download.self, from: data)
                    return Emotion(name: result.instance_1.dominant_emotion)
                })
            }
            .resume()
        } catch {
            process(.failure(error))
        }
    }
}
