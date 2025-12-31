//
//  OrphanExercisesSectionView.swift
//  carac
//
//  Created by Jordan Chap on 22.12.2025.
//

import SwiftData
import SwiftUI

struct OrphanExercisesSectionView: View {
    @Query var exercises: [Exercise]

    @State private var selectedOrphanExercise: Exercise? = nil

    let correctExercisesName: [String]

    private var orphanExercises: [Exercise] {
        let correctExercisesNameSet = Set(correctExercisesName)
        return exercises.filter { exercise in
            !correctExercisesNameSet.contains(exercise.name) && !exercise.sets.isEmpty
        }
    }

    var body: some View {
        if !orphanExercises.isEmpty {
            Section("Orphan exercises") {
                ForEach(orphanExercises, id: \.persistentModelID) { exercise in
                    Button {
                        selectedOrphanExercise = exercise
                    } label: {
                        HStack {
                            Text(exercise.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            .sheet(item: $selectedOrphanExercise) { orphanExercise in
                OrphanExercisesCorrectionSheetView(wrongExerciseName: orphanExercise.name, correctExercisesName: correctExercisesName)
            }
        }
    }
}
