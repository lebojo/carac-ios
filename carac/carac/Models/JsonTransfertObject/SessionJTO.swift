//
//  SessionJTO.swift
//  carac
//
//  Created by Jordan Chap on 23.01.2026.
//

import Foundation

// MARK: - JTOs

struct SessionJTO: Codable {
    let date: Date
    let training: TrainingJTO

    private init(date: Date, training: TrainingJTO) {
        self.date = date
        self.training = training
    }

    init(from session: Session) {
        self.init(
            date: session.date,
            training: TrainingJTO(from: session.training).noRepeatDays
        )
    }
}
