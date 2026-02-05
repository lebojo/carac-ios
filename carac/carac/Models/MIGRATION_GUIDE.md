# SwiftData Schema Migration Plan

## Overview

This project now uses SwiftData's schema migration plan to manage data model changes over time. This enables safe and structured migrations when updating the data model.

## Structure

### Files

- **SchemaV1.swift**: Contains version 1.0.0 of all SwiftData models
  - `ExerciseSet`: Model for a single set of exercises
  - `Exercise`: Model for an exercise with name, weight steps, and sets
  - `Training`: Model for a training program with exercises and repeat days
  - `Session`: Model for a training session with date and training

- **CaracSchemaMigrationPlan.swift**: The migration plan that manages schema versions and migrations
  - Currently contains only SchemaV1
  - Future versions will be added to the `schemas` array
  - Migration stages will be defined in the `stages` array

- **Model Files** (ExerciseSet.swift, Exercise.swift, Training.swift, Session.swift):
  - Use `typealias` to point to the current schema version
  - Contain extensions for convenience initializers and utility methods

## How It Works

1. **Current Implementation**: The app uses `CaracSchemaMigrationPlan` in `caracApp.swift`
2. **Type Aliases**: Each model file uses a typealias (e.g., `typealias Exercise = SchemaV1.Exercise`)
3. **Extensions**: Model-specific methods are added via extensions to keep them separate from the schema definitions

## Adding Future Schema Versions

When you need to modify the data model:

### Step 1: Create a New Schema Version

```swift
enum SchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            ExerciseSet.self,
            Exercise.self,
            Training.self,
            Session.self
        ]
    }
    
    // Define your updated models here with @Model annotation
    @Model
    final class ExerciseSet: Identifiable {
        // ... updated properties
    }
    
    // ... other models
}
```

### Step 2: Update the Migration Plan

```swift
enum CaracSchemaMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            SchemaV1.self,
            SchemaV2.self  // Add new schema
        ]
    }
    
    static var stages: [MigrationStage] {
        [
            migrateV1toV2  // Add migration stage
        ]
    }
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: SchemaV1.self,
        toVersion: SchemaV2.self,
        willMigrate: nil,
        didMigrate: { context in
            // Custom migration logic here
        }
    )
}
```

### Step 3: Update Type Aliases

```swift
// In Exercise.swift
typealias Exercise = SchemaV2.Exercise  // Update to point to new version
```

### Step 4: Update Extensions

Ensure all extensions still work with the new schema version.

## Migration Types

### Lightweight Migration

For simple changes (adding optional properties, renaming properties with @Attribute), SwiftData handles migration automatically.

### Custom Migration

For complex changes (data transformations, deleting properties), define a custom migration stage:

```swift
static let migrateV1toV2 = MigrationStage.custom(
    fromVersion: SchemaV1.self,
    toVersion: SchemaV2.self,
    willMigrate: { context in
        // Pre-migration setup
    },
    didMigrate: { context in
        // Custom migration logic
        let exercises = try context.fetch(FetchDescriptor<SchemaV2.Exercise>())
        for exercise in exercises {
            // Transform data as needed
        }
        try context.save()
    }
)
```

## Best Practices

1. **Never modify existing schema versions** - Always create a new version
2. **Test migrations thoroughly** - Use test data before deploying
3. **Document breaking changes** - Explain why migration is needed
4. **Keep old schemas** - Don't delete previous schema versions
5. **Version incrementally** - Use semantic versioning (major.minor.patch)

## Current Schema (V1)

### ExerciseSet
- `id: Int` - Unique identifier
- `reps: Int` - Number of repetitions
- `weight: Double` - Weight in kilograms

### Exercise
- `name: String` - Exercise name
- `weightSteps: Double` - Weight increment steps
- `sets: [ExerciseSet]` - Array of exercise sets (cascade delete)

### Training
- `title: String` - Training program title
- `exercises: [Exercise]` - Array of exercises
- `repeatDays: [String]` - Days when training repeats
- `sessions: [Session]` - Related sessions (nullify on delete)

### Session
- `date: Date` - Session date
- `training: Training` - Associated training (cascade delete)

## References

- [SwiftData Migration Documentation](https://developer.apple.com/documentation/swiftdata/migrating-your-swiftdata-app)
- [VersionedSchema Protocol](https://developer.apple.com/documentation/swiftdata/versionedschema)
- [SchemaMigrationPlan Protocol](https://developer.apple.com/documentation/swiftdata/schemamigrationplan)
