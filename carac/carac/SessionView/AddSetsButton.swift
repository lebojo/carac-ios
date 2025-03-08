//
//  AddSetsButton.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import SwiftUI

struct AddSetsButton: View {
    @Bindable var exercise: Exercise

    var nextWeight: Double {
        guard let lastSet = exercise.sets.last, lastSet.weight > 1 else {
            return 1
        }
        guard lastSet.reps > 8 else {
            return lastSet.weight - 0.5
        }

        return lastSet.reps >= 12 ? lastSet.weight + 0.5 : lastSet.weight
    }

    var body: some View {
        HStack {
            Button {
                withAnimation {
                    exercise.sets.append(ExerciseSet(
                        id: (exercise.sets.last?.id ?? 0) + 1,
                        reps: exercise.sets.last?.reps ?? 10,
                        weight: nextWeight
                    ))
                }
            } label: {
                Text("Add Set")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
