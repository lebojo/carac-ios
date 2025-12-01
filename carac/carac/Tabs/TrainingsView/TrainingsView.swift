//
//  ExercisesView.swift
//  carac
//
//  Created by Jordan on 14.03.2025.
//

import SwiftData
import SwiftUI

struct TrainingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var mainViewState: MainViewState

    @Query private var trainings: [Training]
    @Query private var exercises: [Exercise]

    private var singleTrainings: [Training] {
        trainings.filter { $0.sessions.isEmpty }
    }

    private var singleExercises: [Exercise] {
        exercises.filter(\.sets.isEmpty)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Trainings") {
                    ForEach(singleTrainings, id: \.persistentModelID) { training in
                        Button {
                            mainViewState.selectedTraining = training
                        } label: {
                            HStack {
                                Text(training.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let trainingToDelete = singleTrainings[index]
                            modelContext.delete(trainingToDelete)
                        }
                    }
                }

                Section("Exercises") {
                    ForEach(singleExercises, id: \.persistentModelID) { exercise in
                        Button {
                            mainViewState.selectedExercise = exercise
                        } label: {
                            HStack {
                                Text(exercise.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                }
            }
            .bottomButton(title: "Create a training", systemName: "plus") {
                mainViewState.selectedState = .createTraining
            }
            .navigationTitle("Carac Training\(trainings.count > 1 ? "s" : "")")
            .toolbar { HomeToolbarView() }
        }
    }
}
