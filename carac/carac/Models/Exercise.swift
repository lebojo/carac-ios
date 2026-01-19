//
//  Exercise.swift
//  carac
//
//  Created by Jordan on 05.03.2025.
//

import Foundation
import SwiftData

@Model
final class Exercise: Identifiable, Codable {
    var name: String
    var weightSteps: Double
    @Relationship(deleteRule: .cascade) var sets: [ExerciseSet]

    init(name: String = "", weightSteps: Double = 1, sets: [ExerciseSet] = []) {
        self.name = name
        self.weightSteps = weightSteps
        self.sets = sets
    }
    
    init(from draft: ExerciseDraft) {
        name = draft.name
        weightSteps = draft.weightSteps
        sets = draft.sets.map { ExerciseSet(from: $0) }
    }

    var totalPulledWeight: Double {
        sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case name, weightSteps, sets
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.weightSteps = try container.decode(Double.self, forKey: .weightSteps)
        self.sets = try container.decode([ExerciseSet].self, forKey: .sets)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(weightSteps, forKey: .weightSteps)
        try container.encode(sets, forKey: .sets)
    }
}
