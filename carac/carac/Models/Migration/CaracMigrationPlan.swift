//
//  CaracMigrationPlan.swift
//  carac
//
//  Created by Jordan Chap on 23.10.2026.
//

import Foundation
import SwiftData

enum CaracMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [CaracSchemaV1.self, CaracSchemaV2.self]
    }

    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }

    nonisolated(unsafe) private static var exerciseKeysByTrainingKey: [Data: [Data]] = [:]

    private static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: CaracSchemaV1.self,
        toVersion: CaracSchemaV2.self,
        willMigrate: { context in
            let trainings = try context.fetch(FetchDescriptor<CaracSchemaV1.Training>())
            exerciseKeysByTrainingKey = try Dictionary(uniqueKeysWithValues: trainings.map { training in
                (try storeKey(of: training), try training.exercises.map(storeKey))
            })
        },
        didMigrate: { context in
            let exercisesByKey = try Dictionary(uniqueKeysWithValues: context.fetch(FetchDescriptor<Exercise>()).map { (try storeKey(of: $0), $0) })

            for training in try context.fetch(FetchDescriptor<Training>()) {
                guard let exerciseKeys = exerciseKeysByTrainingKey[try storeKey(of: training)] else { continue }

                training.exercises = exerciseKeys.compactMap { exercisesByKey[$0] }
            }

            try context.save()
            exerciseKeysByTrainingKey = [:]
        }
    )

    private static func storeKey(of model: any PersistentModel) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return try encoder.encode(model.persistentModelID)
    }
}
