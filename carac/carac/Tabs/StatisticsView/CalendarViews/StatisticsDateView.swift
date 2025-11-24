//
//  StatisticsDateView.swift
//  carac
//
//  Created by Jordan Chap on 24.11.2025.
//

import SwiftData
import SwiftUI

struct StatisticsDateView: View {
    @Environment(\.modelContext) private var context
    @State private var sessions: [Session] = []

    let date: Date

    var body: some View {
        List {
            if sessions.count == 1, let firstSession = sessions.first {
                forEachExercises(firstSession.training.exercises)
            } else {
                ForEach(sessions) { session in
                    Section("\(session.date.formatted(.dateTime))") {
                        forEachExercises(session.training.exercises)
                    }
                }
            }
        }
        .overlay {
            if sessions.isEmpty {
                ContentUnavailableView("No data for this date", systemImage: "text.page.slash")
            }
        }
        .task { await fetchSessions() }
        .refreshable {
            Task {
                await fetchSessions()
            }
        }
    }

    private func fetchSessions() async {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        let descriptor = FetchDescriptor<Session>(
            predicate: #Predicate { $0.date >= start && $0.date < end },
            sortBy: [SortDescriptor(\.date)]
        )

        sessions = (try? context.fetch(descriptor)) ?? []
    }

    @ViewBuilder
    private func forEachExercises(_ exercises: [Exercise]) -> some View {
        ForEach(exercises, id: \.self) { exercise in
            Text(exercise.name)
        }
    }
}

#Preview {
    StatisticsDateView(date: .now)
}
