//
//  ExerciseType.swift
//  carac
//
//  Created by Killian Mathias on 25.07.2026.
//

import Foundation

public enum ExerciseType: String, CaseIterable, Codable, Identifiable {
    case strength = "Strength"
    case cardio = "Cardio"
    case stretching = "Stretching"
    case calisthenics = "Calisthenics"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .strength:
            return "Strength"
        case .cardio:
            return "Cardio"
        case .stretching:
            return "Stretching"
        case .calisthenics:
            return "Calisthenics"
        }
    }

    public var systemImage: String {
        switch self {
        case .strength:
            return "dumbbell.fill"
        case .cardio:
            return "figure.run"
        case .stretching:
            return "figure.cooldown"
        case .calisthenics:
            return "figure.gymnastics"
        }
    }
}
