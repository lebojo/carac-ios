//
//  ExercisesGridSection.swift
//  carac
//
//  Created by Jordan Chap on 21.10.2025.
//

import SwiftData
import SwiftUI

struct ExercisesGridSection: View {
    @Query(filter: #Predicate<Exercise> { $0.sets.isEmpty })
    private var exercises: [Exercise]

    @Binding var trainingExercises: [Exercise]

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        Section("Exercises \(trainingExercises.count)") {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(exercises) { exercise in
                    let isSelected = trainingExercises.contains(
                        where: { $0.id == exercise.id })

                    Button("\(exercise.name)") {
                        if isSelected {
                            if let index = trainingExercises.firstIndex(
                                of: exercise
                            ) {
                                trainingExercises.remove(at: index)
                            }
                        } else {
                            trainingExercises.append(exercise)
                        }
                    }
                    .padding()
                    .buttonStyle(.exerciseButton(isSelected))
                }

                NewExerciseButton()
            }
        }
    }
}

#Preview {
    ExercisesGridSection(trainingExercises: .constant([]))
}
