//
//  ExercisesGridSection.swift
//  carac
//
//  Created by Jordan Chap on 21.10.2025.
//

import SwiftData
import SwiftUI

struct ExercisesGridSection: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var mainViewState: MainViewState

    @Query(filter: #Predicate<Exercise> { $0.sets.isEmpty })
    private var exercises: [Exercise]

    @Binding var trainingExercises: [Exercise]

    var body: some View {
        Section("Selected exercises \(trainingExercises.count)") { // TODO: Find a better way to show it

            NewExerciseButton()
                .frame(maxWidth: .infinity)

            ForEach(exercises) { exercise in
                ExerciseCell(exercise: exercise, trainingExercises: $trainingExercises, isSelected: trainingExercises.contains(where: { $0.id == exercise.id }))
                    .listRowSeparator(.hidden)
            }
        }
    }
}

struct ExerciseCell: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var mainViewState: MainViewState
    let exercise: Exercise
    @Binding var trainingExercises: [Exercise]

    let isSelected: Bool

    var body: some View {
        Button {
            if let index = trainingExercises.firstIndex(of: exercise) {
                trainingExercises.remove(at: index)
            } else {
                trainingExercises.append(exercise)
            }
        } label: {
            Text("\(exercise.name)")
        }
        .padding()
        .buttonStyle(.exerciseButton(isSelected))
        .contextMenu {
            Button("Modify", systemImage: "pencil") {
                mainViewState.selectedExercise = exercise
            }

            Button("Delete", systemImage: "trash", role: .destructive) {
                if let index = trainingExercises.firstIndex(
                    of: exercise
                ) {
                    trainingExercises.remove(at: index)
                }
                modelContext.delete(exercise)
            }
        }
    }
}

#Preview {
    ExercisesGridSection(trainingExercises: .constant([]))
}
