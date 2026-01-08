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
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                mainViewState.selectedTraining = training
                            }
                        } label: {
                            HStack {
                                Text(training.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.tertiary)
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
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                mainViewState.selectedExercise = exercise
                            }
                        } label: {
                            HStack {
                                Text(exercise.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                }

                OrphanExercisesSectionView(correctExercisesName: singleExercises.map(\.name))
            }
            .scrollContentBackground(.hidden)
            .subtleGradientBackground()
            .bottomButton(title: "Create a training", systemName: "plus") {
                mainViewState.selectedState = .createTraining
            }
            .navigationTitle("Carac Training\(trainings.count > 1 ? "s" : "")")
            .toolbar { HomeToolbarView() }
        }
    }
}
