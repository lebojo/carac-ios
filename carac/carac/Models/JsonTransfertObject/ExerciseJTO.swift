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
    let equipment: String?
    let exerciseType: String?
    let sets: [SetJTO]?

    private init(name: String, weightSteps: Double?, equipment: String?, exerciseType: String?, sets: [SetJTO]?) {
        self.name = name
        self.weightSteps = weightSteps
        self.equipment = equipment
        self.exerciseType = exerciseType
        self.sets = sets
    }

    init(from exercise: Exercise) {
        self.init(
            name: exercise.name,
            weightSteps: exercise.weightSteps,
            equipment: exercise.equipment,
            exerciseType: exercise.exerciseType,
            sets: exercise.sets.map { SetJTO(from: $0) }
        )
    }

    var template: ExerciseJTO {
        .init(name: name, weightSteps: weightSteps, equipment: equipment, exerciseType: exerciseType, sets: nil)
    }

    var persistedModel: Exercise {
        Exercise(
            name: name,
            weightSteps: weightSteps ?? 0.5,
            equipment: EquipmentType(rawValue: equipment ?? "") ?? .other,
            exerciseType: ExerciseType(rawValue: exerciseType ?? "") ?? .strength,
            sets: sets?.enumerated().map { ExerciseSet(id: $0.offset, reps: $0.element.repetition, weight: $0.element.weight, duration: $0.element.duration, distance: $0.element.distance) } ?? []
        )
    }
}

