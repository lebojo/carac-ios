//
//  ImportDataFromJsonButtonView.swift
//  carac
//
//  Created by Jordan Chap on 23.01.2026.
//

import SwiftData
import SwiftUI

struct ImportDataFromJsonButtonView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var importedJto: GlobalJTO? = nil
    @State private var isImporting = false

    @State private var errorMessage: String?

    var body: some View {
        Button {
            isImporting = true
        } label: {
            Label("Import from JSON", systemImage: "square.and.arrow.down")
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result: result)
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
        .alert("Backup found!", isPresented: .constant(importedJto != nil)) {
            Button("Cancel", role: .cancel) {
                importedJto = nil
            }

            if let importedJto {
                Button("Import", role: .destructive) {
                    do {
                        try importData(backup: importedJto)
                    } catch {
                        errorMessage = "Error importing: \(error.localizedDescription)"
                    }
                }
            }
        } message: {
            if let importedJto {
                Text("Found a valid backup file from: \(importedJto.savingDate.formatted())\nWith: \(importedJto.sessions.count) sessions and \(importedJto.trainingTemplates.count) templates")
            } else {
                Text("Error, please retry or contact me.")
            }
        }
    }

    private func handleImport(result: Result<[URL], Error>) {
        do {
            guard let fileUrl = try result.get().first else {
                errorMessage = "No file found, please retry."
                return
            }
            guard fileUrl.startAccessingSecurityScopedResource() else {
                errorMessage = "Can't access file, please retry."
                return
            }

            defer { fileUrl.stopAccessingSecurityScopedResource() }

            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            importedJto = try decoder.decode(GlobalJTO.self, from: data)
        } catch {
            errorMessage = "File access error: \(error.localizedDescription)"
        }
    }

    private func importData(backup: GlobalJTO) throws {
        try importTemplates(source: backup.trainingTemplates)
        try importSessions(source: backup.sessions)
        try modelContext.save()
    }

    private func importTemplates(source: [TrainingJTO]) throws {
        let existingTrainings = try modelContext.fetch(FetchDescriptor<Training>())
        let templateTrainings = existingTrainings.filter { $0.sessions.isEmpty }
        let trainingsByTitle = Dictionary(templateTrainings.map { ($0.title, $0) }, uniquingKeysWith: { first, _ in first })

        let existingExercises = try modelContext.fetch(FetchDescriptor<Exercise>())
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

    private func importSessions(source: [SessionJTO]) throws {
        let existingSessions = try modelContext.fetch(FetchDescriptor<Session>())
        let sessionKeys = existingSessions.map { "\($0.date)_\($0.training.title)_\(String(format: "%.2f", $0.totalWeightPulled))" }

        for session in source {
            let sessionKey = "\(session.date)_\(session.training.name)_\(String(format: "%.2f", session.totalWeightPulled))"
            guard !sessionKeys.contains(sessionKey) else { continue }

            let sessionToSave = Session(
                date: session.date,
                training: session.training.persistedModel
            )

            modelContext.insert(sessionToSave)
        }
    }
}

#Preview {
    ImportDataFromJsonButtonView()
}
