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

        let start = Calendar.current.startOfDay(for: .now)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        _todaySessions = Query(filter: #Predicate<Session> { session in
            session.date >= start && session.date < end
        })
    }

    var body: some View {
        if !trainings.isEmpty {
            Section("Today") {
                ForEach(todaySessions, id: \.persistentModelID) { todaySession in
                    Button("Modify \(todaySession.training.title) at \(todaySession.date.twoDigitsHour)", systemImage: "pencil") {
                        let draftSession = SessionDraft(from: todaySession)
                        mainViewState.currentSession = draftSession
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(todaySessions[index])
                    }
                }

                ForEach(trainings) { training in
                    Button {
                        createSession(training)
                    } label: {
                        Text("New **\(training.title)**")
                            .frame(maxWidth: .infinity)
                            .background(.clear)
                            .foregroundStyle(.white)
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .glassEffectStyle(.regular)
                }
            }
        } else {
            ContentUnavailableView(
                "Free day!",
                systemImage: "sun.dust",
                description: Text("Chill, it's \(RepeatDay.today.title.lowercased()). You have nothing to do today.")
            )
        }
    }

    private func createSession(_ training: Training) {
        let draft = SessionDraft(training: TrainingDraft(from: training))
        mainViewState.currentSession = draft
    }
}
