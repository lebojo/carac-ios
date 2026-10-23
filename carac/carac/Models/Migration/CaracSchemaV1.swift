//
//  CaracSchemaV1.swift
//  carac
//
//  Created by Jordan Chap on 23.10.2026.
//

import Foundation
import SwiftData

enum CaracSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Session.self, Exercise.self, ExerciseSet.self, Training.self]
    }

    @Model
    final class Exercise {
        var name: String
        var weightSteps: Double
        @Relationship(deleteRule: .cascade) var sets: [ExerciseSet]

        init(name: String, weightSteps: Double, sets: [ExerciseSet]) {
            self.name = name
            self.weightSteps = weightSteps
            self.sets = sets
        }
    }

    @Model
    final class ExerciseSet {
        var id: Int
        var reps: Int
        var weight: Double

        init(id: Int, reps: Int, weight: Double) {
            self.id = id
            self.reps = reps
            self.weight = weight
        }
    }

    @Model
    final class Session {
        var date: Date
        @Relationship(deleteRule: .cascade) var training: Training

        init(date: Date, training: Training) {
            self.date = date
            self.training = training
        }
    }

    @Model
    final class Training {
        var title: String
        var exercises: [Exercise]
        var repeatDays: [String]

        @Relationship(deleteRule: .nullify, inverse: \Session.training)
        var sessions: [Session] = []

        init(title: String, exercises: [Exercise], repeatDays: [String]) {
            self.title = title
            self.exercises = exercises
            self.repeatDays = repeatDays
        }
    }
}
