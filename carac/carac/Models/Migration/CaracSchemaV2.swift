//
//  CaracSchemaV2.swift
//  carac
//
//  Created by Jordan Chap on 23.10.2026.
//

import SwiftData

enum CaracSchemaV2: VersionedSchema {
    static let versionIdentifier = Schema.Version(2, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Session.self, Exercise.self, ExerciseSet.self, Training.self]
    }
}
