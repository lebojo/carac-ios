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
            Label("Export all Sessions to JSON", systemImage: "square.and.arrow.up")

            if isLoading {
                ProgressView()
            }
        }
        .disabled(isLoading)
        .task {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(allSessions)
                try jsonData.write(to: tempURL)

                isLoading = false
            } catch {
                print("Error saving data: \(error)")
            }
        }
    }
}

#Preview {
    ExportDataToJsonButtonView()
}
