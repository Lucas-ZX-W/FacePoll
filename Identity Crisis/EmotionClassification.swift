//
//  EmotionClassification.swift
//  Identity Crisis
//
//  Created by Apollo Zhu on 10/17/20.
//

import Foundation
import CoreML
import opencv2
//import opencv2.Imgcodecs

enum EmotionClassification {
    private static func crop(_ image: CVPixelBuffer, to rect: CGRect) -> NSImage {
        let ciImage = CIImage(cvPixelBuffer: image)
            .cropped(to: rect)
        //                    .cropped(to: CGRect(x: rect.minX - 100,
        //                                        y: rect.minY - 250,
        //                                        width: rect.width + 200,
        //                                        height: rect.height + 400))
        let representation = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: representation.size)
        nsImage.addRepresentation(representation)
        return nsImage
    }

    private static func convert(_ nsImage: NSImage) throws -> MLMultiArray {
        var mat = Mat(nsImage: nsImage)
        Imgproc.resize(src: mat, dst: mat, dsize: Size(width: 48, height: 48))
        Imgproc.cvtColor(src: mat, dst: mat, code: .COLOR_RGBA2GRAY)
        mat = mat.reshape(channels: 1)
        return try MLMultiArray(dataPointer: mat.dataPointer(),
                                shape: [1, 48, 48],
                                dataType: .float32, strides: [1, 48, 48],
                                deallocator: nil)
    }

    static func classify(image: CVImageBuffer, faceBounds: CGRect,
                         completion process: @escaping (NSImage, Result<Emotion, Error>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let image = crop(image, to: faceBounds)
            do {
                let model = try emotion_detector(configuration: MLModelConfiguration())
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
                    .filter { $0.element.isNormal && $0.element > 0.4 }
                guard !filtered.isEmpty else {
//                     "no emotion detected"
                    return
                }
                process(image, .success(
                    filtered
                        .max { $0.element < $1.element }
                        .flatMap { Emotion(rawValue: $0.offset) }!
                ))
            } catch {
                process(image, .failure(error))
            }
        }
    }
}

extension String: LocalizedError { }

