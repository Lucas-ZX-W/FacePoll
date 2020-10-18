//
//  Emotion.swift
//  Identity Crisis
//
//  Created by Apollo Zhu on 10/17/20.
//

import Foundation
import SwiftUI

enum Emotion: Int, CaseIterable {
    case angry
    case disgust
    case fear
    case happy
    case neutral
    case sad
    case surprise

    static var allCases: [Emotion] = [
        .fear, .angry, .disgust, .sad, .neutral, .surprise, .happy 
    ]
}

extension Emotion: Identifiable {
    var id: Int {
        return rawValue
    }
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

extension Emotion {
    init(name: String) {
        switch name.lowercased() {
        case "angry":
            self = .angry
        case "disgust":
            self = .disgust
        case "fear":
            self = .fear
        case "happy":
            self = .happy
        case "neutral":
            self = .neutral
        case "sad":
            self = .sad
        case "surprise":
            self = .surprise
        default:
            fatalError(name)
        }
    }
}

extension Emotion {
    var color: Color {
        switch self {
            case .angry:
                return .red
            case .disgust:
                return .green
            case .fear:
                return .black
            case .happy:
                return .orange
            case .neutral:
                return .gray
            case .sad:
                return .blue
            case .surprise:
                return .yellow
        }
    }
}
