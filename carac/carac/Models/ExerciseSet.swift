//
//  ExerciseSet.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import Foundation
import SwiftData

typealias ExerciseSet = SchemaV1.ExerciseSet

extension ExerciseSet {
    convenience init(from draft: ExerciseSetDraft) {
        self.init(id: draft.id, reps: draft.reps, weight: draft.weight)
    }
}
