//
//  TrainingCreationView.swift
//  carac
//
//  Created by Jordan Chap on 18.10.2025.
//

import SwiftData
import SwiftUI

struct TrainingCreationView: View {
    @EnvironmentObject var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    @State private var newTraining = Training("")

    @Query(filter: #Predicate<Exercise> { $0.sets.isEmpty })
    private var exercises: [Exercise]

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Name")
                        TextField(text: $newTraining.title) {
                            Text("Top body training")
                        }
                        .multilineTextAlignment(.trailing)
                    }

                    NavigationLink(
                        "Training days",
                        destination: RepeatDayPicker(newTraining: newTraining)
                    )
                } header: {
                    Text("Main info")
                } footer: {
                    if !newTraining.title.isEmpty
                        && !newTraining.repeatDays.isEmpty
                    {
                        Text(
                            "\(newTraining.title) should be done every \(newTraining.repeatDays.joined(separator: ", "))"
                        )
                    }
                }

                Section("Exercises \(newTraining.exercises.count)") {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(exercises) { exercise in
                            let isSelected = newTraining.exercises.contains(
                                where: { $0.id == exercise.id })
                            Button("\(exercise.name)") {
                                if isSelected {
                                    if let index = newTraining.exercises
                                        .firstIndex(of: exercise)
                                    {
                                        newTraining.exercises.remove(at: index)
                                    }
                                } else {
                                    newTraining.exercises.append(exercise)
                                }
                            }
                            .padding()
                            .buttonStyle(.exerciseButton(isSelected))
                        }

                        NewExerciseButton()
                    }
                }
            }
            .closeButton()
            .navigationTitle("New training")
            .animation(.easeInOut, value: newTraining.exercises)
            .bottomButton(title: "Create now", systemName: "calendar.badge.plus", disabled: newTraining.exercises.isEmpty) {
                modelContext.insert(newTraining)

                mainViewState.selectedState = nil
            }
        }
    }
}



#Preview {
    TrainingCreationView()
        .environmentObject(sampleMainViewState)
}
