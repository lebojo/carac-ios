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

    let trainings: [Training]

    var body: some View {
        if trainings.isEmpty {
            Button {
//                createSession()
                print("OUIII")
            } label: {
                Text("Start a training")
            }
        } else {
            ContentUnavailableView(
                "You did your training today!",
                systemImage: "sun.dust",
                description: Text("Chill, it's \(RepeatDay.today.title.lowercased()). You have nothing to do today.")
            )
        }
    }

//    private func createSession() {
//        let newSession = Session(training: )
//        modelContext.insert(newSession)
//
//        // Si vous avez les IDs des exercices
//        let exerciseIDs = exercises.map { $0.persistentModelID }
//
//        for exerciseID in exerciseIDs {
//            if let contextExercise = modelContext.model(for: exerciseID) as? Exercise {
//                newSession.exercises.append(contextExercise)
//            }
//        }
//
//        session = newSession
//        mainViewState.selectedSession = newSession
//    }
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
