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
        .alert("Erreur d'import", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func handleImport(result: Result<[URL], Error>) {
        do {
            guard let fileUrl = try result.get().first else { return }
            guard fileUrl.startAccessingSecurityScopedResource() else { return }
            defer { fileUrl.stopAccessingSecurityScopedResource() }

            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let backup = try decoder.decode(GlobalJTO.self, from: data)

            try importData(backup: backup)

        } catch {
            errorMessage = "Impossible d'importer: \(error.localizedDescription)"
        }
    }

    private func importData(backup: GlobalJTO) throws {
        try importTemplates(source: backup.trainingTemplates)
        try importSessions(source: backup.sessions)
        try modelContext.save()
    }

    private func importTemplates(source: [TrainingJTO]) throws {
        let existingTrainings = try modelContext.fetch(FetchDescriptor<Training>())
        let trainingsByTitle = Dictionary(existingTrainings.map { ($0.title, $0) }, uniquingKeysWith: { first, _ in first })

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
        let sessionKeys = Set(existingSessions.map { "\($0.date)_\($0.training.title)_\($0.totalWeightPulled)" })
        print("\(sessionKeys)")
        print("-----")

        for session in source {
            let sessionKey = "\(session.date)_\(session.training.name)_\(session.totalWeightPulled)"
            guard !sessionKeys.contains(sessionKey) else { continue }
            print("+ \(sessionKey)")

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
