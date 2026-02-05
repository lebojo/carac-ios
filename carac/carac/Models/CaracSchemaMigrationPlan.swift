//
//  CaracSchemaMigrationPlan.swift
//  carac
//
//  Created by GitHub Copilot on 05.02.2026.
//

import Foundation
import SwiftData

enum CaracSchemaMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            SchemaV1.self
        ]
    }
    
    static var stages: [MigrationStage] {
        [
            // Future migration stages will be added here
        ]
    }
}
