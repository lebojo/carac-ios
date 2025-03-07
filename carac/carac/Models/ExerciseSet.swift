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
    var date = Date.now

    init(id: Int, reps: Int = 1, weight: Double = 1, date: Date = Date.now) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.date = date
    }
}
