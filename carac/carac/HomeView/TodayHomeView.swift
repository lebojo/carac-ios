//
//  TodayHomeView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct TodayHomeView: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var mainViewState: MainViewState

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

    private func createSession() {
        let session = Session(exercises: exercises)

        modelContext.insert(session)
        mainViewState.mainPath.append(session)
    }
}

#Preview {
    TodayHomeView(exercises: [sampleExercise, sampleExercise])
        .environmentObject(sampleMainViewState)
}
