//
//  Session.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Foundation
import SwiftData

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

    init(_ title: String, exercises: [Exercise] = [], repeatDays: [RepeatDay] = []) {
        self.title = title
        self.exercises = exercises
        self.repeatDays = repeatDays.map(\.rawValue)
    }
    
    init(from copy: Training) {
        self.title = copy.title
        self.repeatDays = copy.repeatDays
        
        self.exercises = copy.exercises.map { Exercise(name: $0.name, weightSteps: $0.weightSteps) }
    }
    
    init(from draft: TrainingDraft) {
        title = draft.title
        exercises = draft.exercises.map { Exercise(from: $0) }
        repeatDays = draft.repeatDays
    }

    func update(with draft: TrainingDraft) {
        title = draft.title
        exercises = draft.exercises.map { Exercise(from: $0) }
        repeatDays = draft.repeatDays
    }
}
