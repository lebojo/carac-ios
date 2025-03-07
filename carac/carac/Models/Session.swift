//
//  Session.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Foundation
import SwiftData

@Model
final class Session {
    var date: Date
    @Relationship(deleteRule: .cascade) var exercises: [Exercise]

    init(date: Date = .now, exercises: [Exercise] = []) {
        self.date = date
        self.exercises = exercises
    }
}
