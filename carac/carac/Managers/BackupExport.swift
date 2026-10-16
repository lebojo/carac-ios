//
//  BackupExport.swift
//  carac
//
//  Created by Jordan Chap on 16.10.2026.
//

import CoreTransferable
import SwiftData
import UniformTypeIdentifiers

struct BackupExport: Transferable {
    let modelContainer: ModelContainer

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .json) { export in
            try await export.encodedBackup()
        }
        .suggestedFileName("caracBackup_\(Date.now.formatted(.dateTime.day().month().year())).json")
    }

    @MainActor
    private func encodedBackup() throws -> Data {
        let modelContext = modelContainer.mainContext
        let sessions = try modelContext.fetch(FetchDescriptor<Session>())
        let templates = try modelContext.fetch(FetchDescriptor<Training>(predicate: Training.templatePredicate))
        return try GlobalJTO(sessions: sessions, templates: templates).encoded()
    }
}
