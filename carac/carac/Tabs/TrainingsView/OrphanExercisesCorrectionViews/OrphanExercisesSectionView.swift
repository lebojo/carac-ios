//
//  OrphanExercisesSectionView.swift
//  carac
//
//  Created by Jordan Chap on 22.12.2025.
//

import SwiftData
import SwiftUI

struct OrphanExercisesSectionView: View {
    @State private var selectedOrphanExercise: Exercise? = nil

    @Query(filter: #Predicate<Exercise> { !$0.sets.isEmpty }) private var exercisesWithSets: [Exercise]

    let correctExercisesName: [String]

    private var orphanExercises: [Exercise] {
        let correctExercisesNameSet = Set(correctExercisesName)
        return exercisesWithSets.filter { !correctExercisesNameSet.contains($0.name) }
    }

    var body: some View {
        let orphanExercises = orphanExercises
        if !orphanExercises.isEmpty {
            Section("Orphan exercises") {
                ForEach(orphanExercises, id: \.persistentModelID) { exercise in
                    ChevronRowButton(title: exercise.name) {
                        selectedOrphanExercise = exercise
                    }
                }
            }
            .sheet(item: $selectedOrphanExercise) { orphanExercise in
                OrphanExercisesCorrectionSheetView(wrongExerciseName: orphanExercise.name, correctExercisesName: correctExercisesName)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium])
            }
        }
    }
}
