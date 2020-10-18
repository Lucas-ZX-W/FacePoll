//
//  Aggregated.swift
//  Identity Crisis
//
//  Created by Apollo Zhu on 10/18/20.
//

import Foundation
import FirebaseDatabase

class Aggregated: ObservableObject {
    let session: String
    private var timer: Timer?
    init(session: String, debug: Bool = false) {
        self.session = session
        database.child(session).observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String : Int] else { return }
            let total = Double(value.count)
            self.reactions = Dictionary(grouping: value.values) { element in
                Emotion(rawValue: element) ?? .neutral
            }.mapValues {
                Double($0.count) / total
            }
        }
        guard debug else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
            [weak self] _ in guard let self = self else { return }
            self.reactions = self.fakeEmotionDistribution()
            // self.fakeStats = self.fakeEmotionDistribution()
        }
    }

    deinit {
        timer?.invalidate()
    }

    /// https://stackoverflow.com/a/8064754
    private func fakeEmotionDistribution() -> [Emotion: Double] {
        var nums = [0, 100]
        for _ in 0..<6 {
            nums.append(Int.random(in: 0...100))
        }
        nums.sort()
        return Dictionary(
            uniqueKeysWithValues:
                zip(nums.dropFirst(), nums.dropLast())
                .map { $0 - $1 }
                .enumerated()
                .map { (Emotion(rawValue: $0.offset)!, Double($0.element) / 100) }
        )
    }

    @Published var reactions: [Emotion: Double] = [:]
    @Published var fakeStats: [Emotion: Double] = [.angry: 0.2, .disgust: 0.1, .fear: 0.05, .happy: 0.01, .neutral: 0.09, .sad: 0.4, .surprise: 0.15]
}
