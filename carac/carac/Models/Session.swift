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
    @Relationship(deleteRule: .cascade) var training: Training

    init(date: Date = .now, training: Training) {
        self.date = date
        self.training = training
    }
}
