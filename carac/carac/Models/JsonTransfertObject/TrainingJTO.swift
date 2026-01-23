//
//  TrainingJTO.swift
//  carac
//
//  Created by Jordan Chap on 23.01.2026.
//

import Foundation

struct TrainingJTO: Codable, Hashable {
    let name: String
    let exercises: [ExerciseJTO]

    private init(name: String, exercises: [ExerciseJTO]) {
        self.name = name
        self.exercises = exercises
    }

    init(from training: Training) {
        self.init(
            name: training.title,
            exercises: training.exercises.map { ExerciseJTO(from: $0) }
        )
    }

    var template: TrainingJTO {
        .init(name: name, exercises: exercises.map(\.template))
    }

    static func == (lhs: TrainingJTO, rhs: TrainingJTO) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
