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

    @State private var session: Session?
    
    @Query private var sessions: [Session]
    
    private var todaySessions: [Session] {
        sessions.filter{ Calendar.current.isDateInToday($0.date) }
    }

    let trainings: [Training]

    var body: some View {
        if !trainings.isEmpty {
            ForEach(todaySessions) { todaySession in
                Button("Modify \(todaySession.training.title) at \(todaySession.date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits)))") {
                    mainViewState.currentSession = todaySession
                }
            }

            ForEach(trainings) { training in
                Button {
                    createSession(training)
                } label: {
                    if todaySessions.isEmpty {
                        Text("Start a \(training.title)")
                    } else {
                        Text("Start a new \(training.title) session")
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
        session = Session(training: Training(from: training))
        if let session {
            modelContext.insert(session)
            mainViewState.currentSession = session
        } else {
            print("Error while creating Session")
        }
    }
}

//#Preview {
//    List {
//        Section("Test empty") {
//            TodayHomeView(exercises: [])
//                .environmentObject(sampleMainViewState)
//        }
//        Section("Test fill") {
//            TodayHomeView(exercises: [sampleExercise, sampleExercise])
//                .environmentObject(sampleMainViewState)
//        }
//    }
//}
