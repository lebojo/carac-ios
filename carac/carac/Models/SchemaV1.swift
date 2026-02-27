//
//  SchemaV1.swift
//  carac
//
//  Created by GitHub Copilot on 05.02.2026.
//

import Foundation
import SwiftData

enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            ExerciseSet.self,
            Exercise.self,
            Training.self,
            Session.self
        ]
    }
    
    @Model
    final class ExerciseSet: Identifiable {
        var id: Int
        var reps: Int
        var weight: Double // In KG

        init(id: Int, reps: Int = 1, weight: Double = 1) {
            self.id = id
            self.reps = reps
            self.weight = weight
        }
    }
    
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

        var totalPulledWeight: Double {
            sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
        }
    }
    
    @Model
    final class Training: Identifiable {
        var title: String
        var exercises: [Exercise]
        var repeatDays: [String]

        @Relationship(deleteRule: .nullify, inverse: \Session.training)
        var sessions: [Session] = []

        var totalWeightPulled: Double {
            sessions.reduce(0) { $0 + $1.totalWeightPulled }
        }

        var repeatDaysStringified: String {
            repeatDays.joined(separator: ", ")
        }

        init(_ title: String, exercises: [Exercise] = [], repeatDays: [String] = []) {
            self.title = title
            self.exercises = exercises
            self.repeatDays = repeatDays
        }
        
        init(_ title: String, exercises: [Exercise] = [], repeatDaysEnum: [RepeatDay] = []) {
            self.title = title
            self.exercises = exercises
            self.repeatDays = repeatDaysEnum.map(\.rawValue)
        }
    }
    
    @Model
    final class Session {
        var date: Date
        @Relationship(deleteRule: .cascade) var training: Training

        init(date: Date = .now, training: Training) {
            self.date = date
            self.training = training
        }

        var totalWeightPulled: Double {
            training.exercises.reduce(0) { $0 + $1.totalPulledWeight }
        }
    }
}
