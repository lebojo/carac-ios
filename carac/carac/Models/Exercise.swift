//
//  Exercise.swift
//  carac
//
//  Created by Jordan on 05.03.2025.
//

import Foundation
import SwiftData

@Model
final class Exercise: Identifiable {
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
}
