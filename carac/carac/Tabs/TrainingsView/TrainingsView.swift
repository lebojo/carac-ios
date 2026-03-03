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

    @State private var navigationPath = NavigationPath()
    @State private var isTrainingCreationShow = false
    @State private var searchText: String = ""

    private var singleTrainings: [Training] {
        trainings.filter { $0.sessions.isEmpty }
    }

    private var singleExercises: [Exercise] {
        exercises.filter(\.sets.isEmpty)
    }

    private var filteredTrainings: [Training] {
        guard !searchText.isEmpty else { return singleTrainings }
        return singleTrainings.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    private var filteredExercises: [Exercise] {
        guard !searchText.isEmpty else { return singleExercises }
        return singleExercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Section {
                    ForEach(filteredTrainings, id: \.persistentModelID) { training in
                        Button {
                            navigationPath.append(training)
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
                            let trainingToDelete = filteredTrainings[index]
                            modelContext.delete(trainingToDelete)
                        }
                    }
                } header: {
                    Text("Trainings")
                } footer: {
                    Button("Create a new training", systemImage: "plus") {
                        isTrainingCreationShow = true
                    }
                    .glassButton()
                    .frame(maxWidth: .infinity)
                }

                Section("Exercises") {
                    ForEach(filteredExercises, id: \.persistentModelID) { exercise in
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

                OrphanExercisesSectionView(correctExercisesName: singleExercises.map(\.name))
            }
            .toolbar { HomeToolbarView() }
            .searchable(text: $searchText)
            .navigationTitle("Carac Training\(trainings.count > 1 ? "s" : "")")
            .navigationDestination(for: Training.self) { training in
                TrainingModificationView(training: training)
            }
            .sheet(isPresented: $isTrainingCreationShow) {
                TrainingCreationView()
            }
        }
    }
}
