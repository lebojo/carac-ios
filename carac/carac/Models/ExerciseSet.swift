//
//  ExerciseSet.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import Foundation
import SwiftData

@Model
final class ExerciseSet: Identifiable {
    var id: Int = 0
    var reps: Int = 1
    var weight: Double = 1
    var exercise: Exercise?

    init(id: Int, reps: Int = 1, weight: Double = 1) {
        self.id = id
        self.reps = reps
        self.weight = weight
    }

    init(from draft: ExerciseSetDraft) {
        id = draft.id
        reps = draft.reps
        weight = draft.weight
    }
}
