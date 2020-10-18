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
            self.reactions = .makeFakeEmotionDistribution()
            // self.fakeStats = .makeFakeEmotionDistribution()
        }
    }

    deinit {
        timer?.invalidate()
    }

    @Published var reactions: [Emotion: Double] = [:]
}

extension Dictionary where Key == Emotion, Value == Double {
    /// https://stackoverflow.com/a/8064754
    fileprivate static func makeFakeEmotionDistribution() -> [Emotion: Double] {
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
}

class History: ObservableObject {
    typealias Record = [Emotion: Int64]

    private static let `default`: Record = [
        .angry: 0, .disgust: 0, .fear: 0, .happy: 0, .neutral: 1, .sad: 0, .surprise: 0
    ]

    @Published
    private var stats: Record {
        didSet {
//            UserDefaults.standard.setValue(stats, forKey: "history")
        }
    }

    static let shared = History()

    var normalized: [Emotion: Double] {
        let total = Double(stats.reduce(0) { $0 + $1.value })
        return stats.mapValues { Double($0) / total }
    }

    private init() {
        stats = (UserDefaults.standard.value(forKey: "history") as? [Emotion: Int64])
            ?? History.default
    }

    func record(_ emotion: Emotion) {
        stats[emotion]? += 1
    }
}
