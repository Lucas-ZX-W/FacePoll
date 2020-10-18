//
//  Emotion.swift
//  Identity Crisis
//
//  Created by Apollo Zhu on 10/17/20.
//

import Foundation

enum Emotion: Int, CaseIterable {
    case angry
    case disgust
    case fear
    case happy
    case sad
    case surprise
    case neutral
}

extension Emotion: CustomStringConvertible {
    var description: String {
        switch self {
        case .angry:
            return "😡"
        case .disgust:
            return "🤢"
        case .fear:
            return "😱"
        case .happy:
            return "😊"
        case .neutral:
            return "😐"
        case .sad:
            return "🙁"
        case .surprise:
            return "🤯"
        }
    }
}
