//
//  SessionJTO.swift
//  carac
//
//  Created by Jordan Chap on 23.01.2026.
//

import Foundation

struct SessionJTO: Codable {
    let date: Date
    let training: TrainingJTO

    private init(date: Date, training: TrainingJTO) {
        self.date = date
        self.training = training
    }

    init?(from session: Session) {
        guard let training = session.training else { return nil }

        self.init(
            date: session.date,
            training: TrainingJTO(from: training).noRepeatDays
        )
    }

    var persistedModel: Session {
        Session(date: date, training: training.persistedModel)
    }

    var totalWeightPulled: Double {
        training.exercises.reduce(0) { result, exercise in
            result + (exercise.sets?.reduce(0) { $0 + ($1.weight * Double($1.repetition)) } ?? 0)
        }
    }
}
