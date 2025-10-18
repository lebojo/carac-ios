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
    
    init(_ title: String, exercises: [Exercise] = [], repeatDays: [RepeatDay] = []) {
        self.title = title
        self.exercises = exercises
        self.repeatDays = repeatDays.map(\.rawValue)
    }
}
