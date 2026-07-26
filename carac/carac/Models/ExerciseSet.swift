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
    var id: Int
    var reps: Int
    var weight: Double // In KG
    var duration: Double? // In Minutes
    var distance: Double? // In KM

    init(id: Int, reps: Int = 1, weight: Double = 1, duration: Double? = nil, distance: Double? = nil) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.duration = duration
        self.distance = distance
    }

    init(from draft: ExerciseSetDraft) {
        id = draft.id
        reps = draft.reps
        weight = draft.weight
        duration = draft.duration
        distance = draft.distance
    }
}

