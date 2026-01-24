//
//  TrainingJTO.swift
//  carac
//
//  Created by Jordan Chap on 23.01.2026.
//

import Foundation

struct TrainingJTO: Codable, Hashable {
    let name: String
    let repeatDays: [String]?
    let exercises: [ExerciseJTO]

    private init(name: String, repeatDays: [String]?, exercises: [ExerciseJTO]) {
        self.name = name
        self.repeatDays = repeatDays
        self.exercises = exercises
    }

    init(from training: Training) {
        self.init(
            name: training.title,
            repeatDays: training.repeatDays,
            exercises: training.exercises.map { ExerciseJTO(from: $0) }
        )
    }

    var template: TrainingJTO {
        .init(name: name, repeatDays: repeatDays, exercises: exercises.map(\.template))
    }

    var noRepeatDays: TrainingJTO {
        .init(name: name, repeatDays: nil, exercises: exercises)
    }

    var persistedModel: Training {
        Training(name, exercises: exercises.map(\.persistedModel), repeatDays: repeatDays?.compactMap { RepeatDay(rawValue: $0) } ?? [])
    }

    static func == (lhs: TrainingJTO, rhs: TrainingJTO) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
