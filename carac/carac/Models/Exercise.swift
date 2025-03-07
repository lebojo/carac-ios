//
//  Exercise.swift
//  carac
//
//  Created by Jordan on 05.03.2025.
//

import Foundation
import SwiftData

@Model
final class Exercise: Identifiable {
    var name: String
    var days: [String]
    @Relationship(deleteRule: .cascade) var sets: [ExerciseSet]

    init(name: String = "", days: [RepeatDay] = [RepeatDay.noRepeat], sets: [ExerciseSet] = [ExerciseSet(id: 0)]) {
        self.name = name
        self.sets = sets
        self.days = days.map(\.rawValue)
    }
}
