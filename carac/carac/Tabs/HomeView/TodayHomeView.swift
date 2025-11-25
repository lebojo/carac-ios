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
    
    @Query private var sessions: [Session]
    
    private var todaySessions: [Session] {
        sessions.filter{ Calendar.current.isDateInToday($0.date) }
    }

    let trainings: [Training]

    var body: some View {
        if !trainings.isEmpty {
            ForEach(todaySessions) { todaySession in
                Button("Modify \(todaySession.training.title) at \(todaySession.date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits)))") {
                    let draftSession = SessionDraft(from: todaySession)
                    mainViewState.currentSession = draftSession
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let trainingToDelete = todaySessions[index]
                    withAnimation {
                        modelContext.delete(trainingToDelete)
                        try? modelContext.save()
                    }
                }
            }

            ForEach(trainings) { training in
                Button {
                    createSession(training)
                } label: {
                    if todaySessions.isEmpty {
                        Label("Start your \(training.title)", systemImage: "plus.app")
                    } else {
                        Label("Start a new \(training.title) session", systemImage: "plus.diamond")
                    }
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
