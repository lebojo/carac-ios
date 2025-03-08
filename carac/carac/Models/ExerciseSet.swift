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

    init(id: Int, reps: Int = 1, weight: Double = 1) {
        self.id = id
        self.reps = reps
        self.weight = weight
    }
}
