//
//  ExerciseJTO.swift
//  carac
//
//  Created by Jordan Chap on 23.01.2026.
//

import Foundation

struct ExerciseJTO: Codable {
    let name: String
    let weightSteps: Double?
    let sets: [SetJTO]?

    private init(name: String, weightSteps: Double?, sets: [SetJTO]?) {
        self.name = name
        self.weightSteps = weightSteps
        self.sets = sets
    }

    init(from exercise: Exercise) {
        self.init(
            name: exercise.name,
            weightSteps: exercise.weightSteps,
            sets: exercise.sets.map { SetJTO(from: $0) }
        )
    }

    var template: ExerciseJTO {
        .init(name: name, weightSteps: weightSteps, sets: nil)
    }
}
