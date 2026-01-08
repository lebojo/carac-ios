//
//  TodayHomeView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftData
import SwiftUI

struct TodayHomeView: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var mainViewState: MainViewState

    @Query private var todaySessions: [Session]
    let trainings: [Training]

    init(trainings: [Training]) {
        self.trainings = trainings

        // 2. On calcule les dates bornes
        let start = Calendar.current.startOfDay(for: .now)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        // 3. On initialise la Query avec un Predicate natif
        _todaySessions = Query(filter: #Predicate<Session> { session in
            session.date >= start && session.date < end
        })
    }

    var body: some View {
        if !trainings.isEmpty {
            ForEach(todaySessions, id: \.persistentModelID) { todaySession in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        let draftSession = SessionDraft(from: todaySession)
                        mainViewState.currentSession = draftSession
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Modify \(todaySession.training.title)")
                                .font(.headline)
                            Text(todaySession.date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits)))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .padding()
                    .cardStyle()
                }
                .buttonStyle(.plain)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    modelContext.delete(todaySessions[index])
                }
            }

            ForEach(trainings) { training in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        createSession(training)
                    }
                } label: {
                    if todaySessions.isEmpty {
                        Label("Start your \(training.title)", systemImage: "play.circle.fill")
                            .font(.headline)
                    } else {
                        Label("Start a new \(training.title) session", systemImage: "plus.circle.fill")
                            .font(.headline)
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
            }
        } else {
            ContentUnavailableView(
                "Free day!",
                systemImage: "sun.dust.fill",
                description: Text("Chill, it's \(RepeatDay.today.title.lowercased()). You have nothing to do today.")
            )
        }
    }

    private func createSession(_ training: Training) {
        let draft = SessionDraft(training: TrainingDraft(from: training))
        mainViewState.currentSession = draft
    }
}
