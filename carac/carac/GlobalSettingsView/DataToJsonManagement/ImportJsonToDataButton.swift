//
//  ImportJsonToDataButton.swift
//  carac
//
//  Created by Jordan Chap on 18.01.2026.
//

import SwiftData
import SwiftUI

struct ImportJsonToDataButton: View {
    @Environment(\.modelContext) private var context

    @State private var isImporting = false

    var body: some View {
        Button("Import json data", systemImage: "square.and.arrow.down") {
            isImporting = true
        }
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json]) { result in
            do {
                importData(jsonURL: try result.get(), context: context)
            } catch {
                print("Failed to import json: \(error)")
            }
        }
    }

    private func importData(jsonURL: URL, context: ModelContext) {
        do {
            let data = try Data(contentsOf: jsonURL)
            let importedSessions = try JSONDecoder().decode([Session].self, from: data)

            var existingTitles = try getExistingTemplatesTitles()

            for newSession in importedSessions {
                guard try createNewSessionFromData(newSession) else { continue }

                try createNewTrainingTemplateIfNeeded(newSession, existingTitles: &existingTitles)
            }

            try context.save()
        } catch {
            print("Error : \(error)")
        }
    }

    private func getExistingTemplatesTitles() throws -> Set<String> {
        let descriptorTemplates = FetchDescriptor<Training>(
            predicate: #Predicate { $0.sessions.isEmpty }
        )
        let existingTemplates = try context.fetch(descriptorTemplates)

        return Set(existingTemplates.map { $0.title })
    }

    private func createNewSessionFromData(_ newSession: Session) throws -> Bool {
        let dateResearch = newSession.date

        let descriptor = FetchDescriptor<Session>(
            predicate: #Predicate { $0.date == dateResearch }
        )

        let candidats = try context.fetch(descriptor)

        if candidats.first(where: { $0.training.title == newSession.training.title && $0.totalWeightPulled == newSession.totalWeightPulled }) != nil {
            return false
        } else {
            context.insert(newSession)
        }

        return true
    }

    private func createNewTrainingTemplateIfNeeded(_ newSession: Session, existingTitles: inout Set<String>) throws {
        let titreTraining = newSession.training.title

        if !existingTitles.contains(titreTraining) {
            let newTrainingTemplate = Training(
                titreTraining,
                exercises: newSession.training.exercises.map { Exercise(name: $0.name, weightSteps: $0.weightSteps) },
                repeatDays: newSession.training.repeatDays.compactMap { RepeatDay(rawValue: $0) }
            )

            context.insert(newTrainingTemplate)

            existingTitles.insert(titreTraining)
        }
    }
}

#Preview {
    ImportJsonToDataButton()
}
