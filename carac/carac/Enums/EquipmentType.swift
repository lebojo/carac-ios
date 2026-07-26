//
//  EquipmentType.swift
//  carac
//
//  Created by Killian Mathias on 25.07.2026.
//

import Foundation

public enum EquipmentType: String, CaseIterable, Codable, Identifiable {
    case dumbbell = "Dumbbell"
    case barbell = "Barbell"
    case pulley = "Pulley"
    case machine = "Machine"
    case bodyweight = "Bodyweight"
    case cardioMachine = "Cardio Machine"
    case kettlebell = "Kettlebell"
    case other = "Other"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .dumbbell:
            return "Dumbbell"
        case .barbell:
            return "Barbell"
        case .pulley:
            return "Pulley / Cable"
        case .machine:
            return "Machine"
        case .bodyweight:
            return "Bodyweight"
        case .cardioMachine:
            return "Cardio Machine"
        case .kettlebell:
            return "Kettlebell"
        case .other:
            return "Other"
        }
    }

    public var systemImage: String {
        switch self {
        case .dumbbell:
            return "dumbbell.fill"
        case .barbell:
            return "figure.strengthtraining.traditional"
        case .pulley:
            return "cable.connector.horizontal"
        case .machine:
            return "gearshape.fill"
        case .bodyweight:
            return "figure.gymnastics"
        case .cardioMachine:
            return "figure.run"
        case .kettlebell:
            return "flame.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
}
