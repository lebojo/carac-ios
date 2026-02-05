//
//  Exercise.swift
//  carac
//
//  Created by Jordan on 05.03.2025.
//

import Foundation
import SwiftData

typealias Exercise = SchemaV1.Exercise

extension Exercise {
    convenience init(from draft: ExerciseDraft) {
        self.init(
            name: draft.name,
            weightSteps: draft.weightSteps,
            sets: draft.sets.map { ExerciseSet(from: $0) }
        )
    }
}
