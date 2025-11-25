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
    
    init(from draft: SessionDraft) {
        date = draft.date
        training = Training(from: draft.training)
    }

    var totalWeightPulled: Double {
        training.exercises.reduce(0) { $0 + $1.totalPulledWeight }
    }

    func update(with draft: SessionDraft) {
        date = draft.date
        training.update(with: draft.training)
    }
}
