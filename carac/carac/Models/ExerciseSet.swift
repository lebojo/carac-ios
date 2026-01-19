//
//  ExerciseSet.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import Foundation
import SwiftData

@Model
final class ExerciseSet: Identifiable, Codable {
    var id: Int
    var reps: Int
    var weight: Double // In KG

    init(id: Int, reps: Int = 1, weight: Double = 1) {
        self.id = id
        self.reps = reps
        self.weight = weight
    }

    init(from draft: ExerciseSetDraft) {
        id = draft.id
        reps = draft.reps
        weight = draft.weight
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id, reps, weight
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.reps = try container.decode(Int.self, forKey: .reps)
        self.weight = try container.decode(Double.self, forKey: .weight)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(reps, forKey: .reps)
        try container.encode(weight, forKey: .weight)
    }
}
