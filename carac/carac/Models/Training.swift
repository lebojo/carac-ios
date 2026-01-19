//
//  Training.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Foundation
import SwiftData

@Model
final class Training: Identifiable, Codable {
    var title: String
    var exercises: [Exercise]
    var repeatDays: [String]

    @Relationship(deleteRule: .nullify, inverse: \Session.training)
    var sessions: [Session] = []

    var totalWeightPulled: Double {
        sessions.reduce(0) { $0 + $1.totalWeightPulled }
    }

    var repeatDaysStringified: String {
        repeatDays.joined(separator: ", ")
    }

    init(_ title: String, exercises: [Exercise] = [], repeatDays: [RepeatDay] = []) {
        self.title = title
        self.exercises = exercises
        self.repeatDays = repeatDays.map(\.rawValue)
    }
    
    init(from draft: TrainingDraft) {
        title = draft.title
        exercises = draft.exercises.map { Exercise(from: $0) }
        repeatDays = draft.repeatDays
    }

    func update(with draft: TrainingDraft) {
        title = draft.title
        exercises = draft.exercises.map { Exercise(from: $0) }
        repeatDays = draft.repeatDays
    }

    // MARK: - Codable for Training

    enum CodingKeys: String, CodingKey {
        case title, exercises, repeatDays
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.exercises = try container.decode([Exercise].self, forKey: .exercises)
        self.repeatDays = try container.decode([String].self, forKey: .repeatDays)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(exercises, forKey: .exercises)
        try container.encode(repeatDays, forKey: .repeatDays)
    }
}
