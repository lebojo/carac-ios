//
//  DataBackupMenu.swift
//  carac
//
//  Created by Jordan Chap on 16.10.2026.
//

import SwiftData
import SwiftUI

struct DataBackupMenu: View {
    enum ImportAlert {
        case backupFound(GlobalJTO)
        case failure(String)

        var title: Text {
            switch self {
            case .backupFound:
                Text("Backup found!")
            case .failure:
                Text("Error")
            }
        }
    }

    @Environment(\.modelContext) private var modelContext

    @State private var isFileImporterPresented = false
    @State private var isImporting = false
    @State private var importAlert: ImportAlert?

    private var isImportAlertPresented: Binding<Bool> {
        Binding {
            importAlert != nil
        } set: { isPresented in
            if !isPresented {
                importAlert = nil
            }
        }
    }

    var body: some View {
        Menu {
            ShareLink(item: BackupExport(modelContainer: modelContext.container), preview: SharePreview("Carac backup")) {
                Label("Export all Sessions to JSON", systemImage: "square.and.arrow.up")
            }

            Button("Import from JSON", systemImage: "square.and.arrow.down") {
                isFileImporterPresented = true
            }
        } label: {
            if isImporting {
                ProgressView()
            } else {
                Label("Your data", systemImage: "square.and.arrow.up")
            }
        }
        .disabled(isImporting)
        .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.json]) { result in
            Task {
                await decodeBackup(from: result)
            }
        }
        .alert(importAlert?.title ?? Text(""), isPresented: isImportAlertPresented, presenting: importAlert) { alert in
            switch alert {
            case .backupFound(let backup):
                Button("Cancel", role: .cancel) {}
                Button("Import", role: .destructive) {
                    Task {
                        await importBackup(backup)
                    }
                }
            case .failure:
                Button("OK") {}
            }
        } message: { alert in
            switch alert {
            case .backupFound(let backup):
                Text("Found a valid backup file from: \(backup.savingDate.formatted())\nWith: \(backup.sessions.count) sessions and \(backup.trainingTemplates.count) templates")
            case .failure(let message):
                Text(message)
            }
        }
    }

    private func decodeBackup(from result: Result<URL, Error>) async {
        do {
            let backup = try await BackupManager.decodeBackup(at: result.get())
            importAlert = .backupFound(backup)
        } catch {
            importAlert = .failure(String(localized: "File access error: \(error.localizedDescription)"))
        }
    }

    private func importBackup(_ backup: GlobalJTO) async {
        isImporting = true
        do {
            try await BackupManager.importBackup(backup, into: modelContext.container)
        } catch {
            importAlert = .failure(String(localized: "Error importing: \(error.localizedDescription)"))
        }
        isImporting = false
    }
}

#Preview {
    DataBackupMenu()
        .modelContainer(for: Session.self, inMemory: true)
}
