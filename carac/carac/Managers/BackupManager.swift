//
//  BackupManager.swift
//  carac
//
//  Created by Jordan Chap on 16.10.2026.
//

import Foundation
import SwiftData

enum BackupManager {
    static func decodeBackup(at fileUrl: URL) async throws -> GlobalJTO {
        try await Task.detached {
            let isAccessing = fileUrl.startAccessingSecurityScopedResource()
            defer {
                if isAccessing {
                    fileUrl.stopAccessingSecurityScopedResource()
                }
            }

            return try GlobalJTO(data: Data(contentsOf: fileUrl))
        }.value
    }

    static func importBackup(_ backup: GlobalJTO, into modelContainer: ModelContainer) async throws {
        try await Task.detached {
            let modelContext = ModelContext(modelContainer)
            try importTemplates(backup.trainingTemplates, into: modelContext)
            try importSessions(backup.sessions, into: modelContext)
            try modelContext.save()
        }.value
    }

    private static func importTemplates(_ source: [TrainingJTO], into modelContext: ModelContext) throws {
        guard !source.isEmpty else { return }

        let templateTrainings = try modelContext.fetch(FetchDescriptor<Training>(predicate: Training.templatePredicate))
        let trainingsByTitle = Dictionary(templateTrainings.map { ($0.title, $0) }, uniquingKeysWith: { first, _ in first })

        let doneTrainings = try modelContext.fetch(FetchDescriptor<Training>(predicate: Training.donePredicate))
        let existingExercises = try modelContext.fetch(FetchDescriptor<Exercise>()).excludingSessionCopies(from: doneTrainings)
        var exercisesByName = Dictionary(existingExercises.map { ($0.name, $0) }, uniquingKeysWith: { first, _ in first })

        for template in source {
            guard trainingsByTitle[template.name] == nil else { continue }

            let exercises: [Exercise] = template.exercises.map { importedExercise in
                if let existing = exercisesByName[importedExercise.name] {
                    return existing
                } else {
                    let newExercise = importedExercise.persistedModel
                    modelContext.insert(newExercise)
                    exercisesByName[importedExercise.name] = newExercise
                    return newExercise
                }
            }

            let templateToSave = Training(
                template.name,
                exercises: [],
                repeatDays: template.repeatDays?.compactMap { RepeatDay(rawValue: $0) } ?? []
            )

            modelContext.insert(templateToSave)

            templateToSave.exercises = exercises
        }
    }

    private static func importSessions(_ source: [SessionJTO], into modelContext: ModelContext) throws {
        guard !source.isEmpty else { return }

        let existingSessions = try modelContext.fetch(FetchDescriptor<Session>())
        var sessionKeys = Set(existingSessions.map { "\($0.date)_\($0.training?.title ?? "")_\(String(format: "%.2f", $0.totalWeightPulled))" })

        for session in source {
            let sessionKey = "\(session.date)_\(session.training.name)_\(String(format: "%.2f", session.totalWeightPulled))"
            guard !sessionKeys.contains(sessionKey) else { continue }

            sessionKeys.insert(sessionKey)

            let sessionToSave = Session(
                date: session.date,
                training: session.training.persistedModel
            )

            modelContext.insert(sessionToSave)
        }
    }
}
