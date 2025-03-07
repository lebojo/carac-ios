//
//  ExerciseListView.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import SwiftUI

struct ExerciseListView: View {
    @Bindable var exercise: Exercise

    var body: some View {
        List {
            Section {
                Button {
                    exercise.sets.append(ExerciseSet(id: Int.random(in: 1...1000000)))
                } label: {
                    Text("Add Set")
                }

                if exercise.sets.count > 1 {
                    Button {
                        exercise.sets.removeLast()
                    } label: {
                        Text("Remove Set")
                    }
                }
            } header: {
                Text(exercise.name)
            } footer: {
                Text("\(exercise.sets.count) Sets")
            }

            ForEach(exercise.sets) { set in
                SetView(set: set)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .shadow(radius: 5)
        .padding()
    }
    //            .navigationTitle("Caca") TODO: Fix crash
}

#Preview {
    ExerciseListView(exercise: sampleExercise)
}
