//
//  EmotionClassification.swift
//  Identity Crisis
//
//  Created by Apollo Zhu on 10/17/20.
//

import Foundation
import Vision

enum EmotionClassification {
    static func classify(image: CVImageBuffer, faceBounds: CGRect,
                         options: [VNImageOption: AnyObject],
                         completion process: @escaping (Result<Emotion, Error>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let handler =  VNImageRequestHandler(cvPixelBuffer: image,
                                                // orientation: exifOrientation,
                                                 options: options)
            do {
                let model = try VNCoreMLModel(for: emotion_detector(configuration: .init()).model)
                let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
                    guard let results = request.results else {
                        return process(.failure(error!))
                    }
                    dump(results)
//                    // The `results` will always be `VNClassificationObservation`s,
//                    // as specified by the Core ML model in this project.
//                    let classifications = results as! [VNClassificationObservation]
//
//                    if classifications.isEmpty {
//                        self.classificationLabel.text = "Nothing recognized."
//                    } else {
//                        // Display top classifications ranked by confidence in the UI.
//                        let topClassifications = classifications.prefix(2)
//                        let descriptions = topClassifications.map { classification in
//                            // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
//                           return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
//                        }
//                        self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
//                    }
                })
                request.imageCropAndScaleOption = .scaleFill
                try handler.perform([request])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                process(.failure(error))
            }
        }
    }
}
