//
//  ExportDataToJsonButtonView.swift
//  carac
//
//  Created by Jordan Chap on 18.01.2026.
//

import SwiftUI
import SwiftData

struct ExportDataToJsonButtonView: View {
    @Query private var allSessions: [Session]

    @State private var isLoading = true

    let tempURL = FileManager.default.temporaryDirectory.appending(path: "caracBackup_\(Date.now.formatted(.dateTime.day().month().year())).json")

    var body: some View {
        ShareLink(item: tempURL) {
            HStack {
                if isLoading {
                    ProgressView()
                }

                Label("Export all Sessions to JSON", systemImage: "square.and.arrow.up")
            }
        }
        .disabled(isLoading)
        .task {
            let globalJTO = GlobalJTO(sessions: allSessions)

            do {
                try saveData(data: globalJTO)

                isLoading = false
            } catch {
                print("Error saving data: \(error)")
            }
        }
    }

    private func saveData(data: GlobalJTO) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(data)
        try jsonData.write(to: tempURL)
    }
}

#Preview {
    ExportDataToJsonButtonView()
}
