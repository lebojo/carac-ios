//
//  TrainingType.swift
//  carac
//
//  Created by Killian Mathias on 25.07.2026.
//

import Foundation

public enum TrainingType: String, CaseIterable, Codable, Identifiable {
    case strength = "Strength"
    case cardio = "Cardio"
    case mixed = "Mixed"
    case stretching = "Stretching"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .strength:
            return "Strength"
        case .cardio:
            return "Cardio"
        case .mixed:
            return "Mixed"
        case .stretching:
            return "Stretching"
        }
    }

    public var systemImage: String {
        switch self {
        case .strength:
            return "figure.strengthtraining.traditional"
        case .cardio:
            return "figure.run"
        case .mixed:
            return "figure.crosstraining"
        case .stretching:
            return "figure.cooldown"
        }
    }
}
