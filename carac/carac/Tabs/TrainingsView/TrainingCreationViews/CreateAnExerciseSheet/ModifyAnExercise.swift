//
//  ModifyAnExercise.swift
//  carac
//
//  Created by Jordan on 16.03.2025.
//

import SwiftData
import SwiftUI

struct ModifyAnExercise: View {
    @EnvironmentObject var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    @Query private var allTrainings: [Training]

    @Bindable var exercise: Exercise

    private var trainings: [Training] {
        allTrainings.filter { $0.exercises.contains { $0.name == exercise.name } }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Carac") {
                    HStack {
                        Text("Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField(text: $exercise.name) {
                            Text("Curl Series")
                        }
                        .multilineTextAlignment(.trailing)
                    }
                }

                Section {
                    VStack {
                        Stepper("Wheight step: **\(exercise.weightSteps.formatted())**", value: $exercise.weightSteps, step: 0.1)

                        Picker("Picker template", selection: $exercise.weightSteps) {
                            ForEach([1, 2.5, 5, 10], id: \.self) { num in
                                Text(num, format: .number.precision(.fractionLength(1)))
                                    .tag(num)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                } footer: {
                    Text("Wheight step is used to precisely measure the weight of the exercise.")
                }

                Text("This exercise is used in:\n\(trainings.map(\.title).joined(separator: "\n"))")
            }
            .navigationTitle("Modify the exercise")
            .closeButton()
            .bottomButton(title: "Update now", systemName: "pencil.and.outline", disabled: exercise.name.isEmpty) {
                do {
                    try modelContext.save()
                } catch {
                    print("Can't update exercise: \(error)")
                }
                mainViewState.selectedExercise = nil
            }
        }
    }
}
