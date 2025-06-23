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

    let exercises: [Exercise]

    var body: some View {
        if exercises.isEmpty {
            ContentUnavailableView(
                "No exercises today",
                systemImage: "sun.dust",
                description: Text("Chill, it's \(RepeatDay.today.title.lowercased()). You have nothing to do today.")
            )
        } else {
            Button {
                createSession()
            } label: {
                Text("Today exercices: \(exercises.count)")
            }
        }
    }

//    private func createSession() {
//        session = Session(exercises: exercises)
//
//        if let session {
//            modelContext.insert(session)
//            mainViewState.selectedSession = session
//        }
//    }
    private func createSession() {
        let newSession = Session()
        modelContext.insert(newSession)

        // Si vous avez les IDs des exercices
        let exerciseIDs = exercises.map { $0.persistentModelID }

        for exerciseID in exerciseIDs {
            if let contextExercise = modelContext.model(for: exerciseID) as? Exercise {
                newSession.exercises.append(contextExercise)
            }
        }

        session = newSession
        mainViewState.selectedSession = newSession
    }
}

#Preview {
    TodayHomeView(exercises: [sampleExercise, sampleExercise])
        .environmentObject(sampleMainViewState)
}
