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
    case sad
    case surprise
    case neutral
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
