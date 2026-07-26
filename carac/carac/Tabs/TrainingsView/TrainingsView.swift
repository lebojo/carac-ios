//
//  ExercisesView.swift
//  carac
//
//  Created by Jordan on 14.03.2025.
//

import SwiftData
import SwiftUI

enum TrainingsDisplayMode: String, CaseIterable {
    case trainings = "Trainings"
    case exercises = "Exercises"
}

struct TrainingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var mainViewState: MainViewState

    @Query private var trainings: [Training]
    @Query private var exercises: [Exercise]

    @State private var navigationPath = NavigationPath()
    @State private var isShowingAddTrainingSheet: Bool = false
    @State private var isShowingAddExerciseSheet: Bool = false
    @State private var displayMode: TrainingsDisplayMode = .trainings

    private var singleTrainings: [Training] {
        trainings.filter { $0.sessions.isEmpty }
    }

    private var singleExercises: [Exercise] {
        exercises.filter(\.sets.isEmpty)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                switch displayMode {
                case .trainings:
                    trainingsContent
                case .exercises:
                    exercisesContent
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Display mode", selection: $displayMode) {
                        ForEach(TrainingsDisplayMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 220)
                }
                AddToolbarView(
                    isShowingAddExerciseSheet: $isShowingAddExerciseSheet,
                    isShowingAddTrainingSheet: $isShowingAddTrainingSheet
                )
            }
            .navigationTitle("Carac Training\(trainings.count > 1 ? "s" : "")")
            .navigationDestination(for: Training.self) { training in
                TrainingModificationView(training: training)
            }
            .sheet(isPresented: $isShowingAddExerciseSheet) {
                CreateAnExerciseSheetView(isPresented: $isShowingAddExerciseSheet)
            }
            .sheet(isPresented: $isShowingAddTrainingSheet) {
                TrainingCreationView()
            }
        }
    }

    // MARK: - Trainings

    @ViewBuilder
    private var trainingsContent: some View {
        if singleTrainings.isEmpty {
            ContentUnavailableView(
                "No trainings.",
                systemImage: "figure.strengthtraining.traditional",
                description: Text("You can add one easily")
            )
        } else {
            List {
                Section {
                    ForEach(singleTrainings, id: \.persistentModelID) { training in
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
                            let trainingToDelete = singleTrainings[index]
                            modelContext.delete(trainingToDelete)
                        }
                    }
                } header: {
                    Text("Trainings")
                }
            }
            .caracListStyle()
        }
    }

    // MARK: - Exercises

    @ViewBuilder
    private var exercisesContent: some View {
        if singleExercises.isEmpty {
            ContentUnavailableView(
                "No exercises.",
                systemImage: "dumbbell",
                description: Text("You can add one easily")
            )
        } else {
            List {
                Section("Exercises") {
                    ForEach(singleExercises, id: \.persistentModelID) { exercise in
                        Button {
                            mainViewState.selectedExercise = exercise
                        } label: {
                            HStack {
                                let type = ExerciseType(rawValue: exercise.exerciseType) ?? .strength
                                let eq = EquipmentType(rawValue: exercise.equipment) ?? .other
                                Image(systemName: type.systemImage)
                                    .foregroundStyle(.secondary)
                                Text(exercise.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(eq.title)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                }

                OrphanExercisesSectionView(correctExercisesName: singleExercises.map(\.name))
            }
            .caracListStyle()
        }
    }

//    private var CreateTrainingButton: some View {
//        Button("Create a new training", systemImage: "plus") {
//            activeSheet = .addTraining
//        }
//        .glassButton()
//        .frame(maxWidth: .infinity)
//    }
}
