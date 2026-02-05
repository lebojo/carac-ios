//
//  Training.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Foundation
import SwiftData

typealias Training = SchemaV1.Training

extension Training {
    convenience init(from copy: Training) {
        self.init(copy.title, exercises: copy.exercises.map { Exercise(name: $0.name, weightSteps: $0.weightSteps) }, repeatDays: copy.repeatDays)
    }
    
    convenience init(from draft: TrainingDraft) {
        self.init(
            draft.title,
            exercises: draft.exercises.map { Exercise(from: $0) },
            repeatDays: draft.repeatDays
        )
    }
    
    convenience init(_ title: String, exercises: [Exercise] = [], repeatDays: [RepeatDay] = []) {
        self.init(title, exercises: exercises, repeatDaysEnum: repeatDays)
    }

    func update(with draft: TrainingDraft) {
        title = draft.title
        exercises = draft.exercises.map { Exercise(from: $0) }
        repeatDays = draft.repeatDays
    }
}
