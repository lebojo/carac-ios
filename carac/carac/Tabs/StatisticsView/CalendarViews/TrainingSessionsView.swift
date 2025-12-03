//
//  TrainingSessionsView.swift
//  carac
//
//  Created by Jordan Chap on 03.12.2025.
//

import SwiftData
import SwiftUI

struct TrainingSessionsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var sessions: [Session] = []

    let training: Training

    var body: some View {
        List {
            if sessions.isEmpty {
                ContentUnavailableView("No sessions for this training", systemImage: "figure.run.circle")
            } else {
                ForEach(sessions, id: \.persistentModelID) { session in
                    VStack(alignment: .leading) {
                        Text(session.date.formatted(.dateTime.day().month().year()))
                            .font(.headline)
                        Text(session.date.formatted(.dateTime.hour().minute()))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Total: \(session.totalWeightPulled.maxDigits())")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: deleteSessions)
            }
        }
        .navigationTitle(training.title)
        .task { await fetchSessions() }
        .refreshable {
            Task {
                await fetchSessions()
            }
        }
    }

    private func fetchSessions() async {
        let trainingTitle = training.title

        let descriptor = FetchDescriptor<Session>(
            predicate: #Predicate { $0.training.title == trainingTitle },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )

        sessions = (try? modelContext.fetch(descriptor)) ?? []
    }

    private func deleteSessions(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sessions[index])
        }
        Task {
            await fetchSessions()
        }
    }
}

#Preview {
    TrainingSessionsView(training: Training("Preview Training"))
}
