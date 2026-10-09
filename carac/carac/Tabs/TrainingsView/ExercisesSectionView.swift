//
//  ExercisesSectionView.swift
//  carac
//
//  Created by Jordan on 07.10.2026.
//

import SwiftData
import SwiftUI

struct ExercisesSectionView: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject private var mainViewState: MainViewState

    let exercises: [Exercise]
    let onCreate: () -> Void

    var body: some View {
        if !exercises.isEmpty {
            Section("Exercises") {
                ForEach(exercises, id: \.persistentModelID) { exercise in
                    ChevronRowButton(title: exercise.name) {
                        mainViewState.selectedExercise = exercise
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(exercises[index])
                    }
                }
            }

            OrphanExercisesSectionView(correctExercisesName: exercises.map(\.name))
        } else {
            ContentUnavailableView {
                Label("No exercises yet", systemImage: "dumbbell")
            } description: {
                Text("Create your first exercise to add it to your trainings.")
            } actions: {
                Button("Create a new exercise", systemImage: "plus", action: onCreate)
                    .glassButton()
            }
        }
    }
}
