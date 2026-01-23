//
//  SetJTO.swift
//  carac
//
//  Created by Jordan Chap on 23.01.2026.
//

import Foundation

struct SetJTO: Codable {
    let repetition: Int
    let weight: Double

    private init(repetition: Int, weight: Double) {
        self.repetition = repetition
        self.weight = weight
    }

    init(from set: ExerciseSet) {
        self.init(repetition: set.reps, weight: set.weight)
    }
}
