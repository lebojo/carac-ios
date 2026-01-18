//
//  Session.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Foundation
import SwiftData

@Model
final class Session: Codable {
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

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case date, training
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        training = try container.decode(Training.self, forKey: .training)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(training, forKey: .training)
    }
}
