//
//  TrainingExerciseListView.swift
//  carac
//
//  Created by Jordan Chap on 03.11.2025.
//

import SwiftUI

struct TrainingExerciseListView: View {
    @EnvironmentObject private var mainViewState: MainViewState

    @State private var showConfirmation: Bool = false
    @State private var alertType: EndSessionAlertViewModifier.EndSessionType = .save
    @State private var isShowingAddExercise: Bool = false

    @Binding var session: SessionDraft

    var body: some View {
        List {
            if session.training.exercises.isEmpty {
                ContentUnavailableView(
                    "No exercises in session",
                    systemImage: "dumbbell",
                    description: Text("Tap below to add your first exercise.")
                )
            } else {
                ForEach($session.training.exercises) { $exercise in
                    NavigationLink {
                        ExerciseDraftView(exercise: $exercise)
                    } label: {
                        HStack {
                            let type = ExerciseType(rawValue: exercise.exerciseType) ?? .strength
                            Image(systemName: type.systemImage)
                                .foregroundStyle(.secondary)

                            Text(exercise.name)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if let firstSet = exercise.sets.first {
                                if exercise.exerciseType == ExerciseType.cardio.rawValue {
                                    Text("\((firstSet.duration ?? 15.0).maxDigits(1)) min - \((firstSet.distance ?? 3.0).maxDigits(2)) km")
                                        .italic()
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("\(firstSet.weight.maxDigits(2)) kg")
                                        .italic()
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    session.training.exercises.remove(atOffsets: indexSet)
                }
                .onMove(perform: moveExercises)
            }

            Section {
                Button {
                    isShowingAddExercise = true
                } label: {
                    Label("Add exercise to session", systemImage: "plus.circle.fill")
                        .foregroundStyle(.primary)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .caracListStyle()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close", systemImage: "xmark") {
                    alertType = .cancel
                    showConfirmation = true
                }
            }

            ToolbarItem(placement: .automatic) {
                EditButton()
            }

            ToolbarItem(placement: .confirmationAction) {
                Button {
                    alertType = session.persistedSession != nil ? .modify : .save
                    showConfirmation = true
                } label: {
                    Label("Save now", systemImage: "checkmark")
                }
            }
        }
        .sheet(isPresented: $isShowingAddExercise) {
            AddExerciseToSessionSheetView(exercises: $session.training.exercises)
        }
        .endSessionAlert(isPresented: $showConfirmation, sessionDraft: session, type: alertType)
        .navigationTitle(session.training.title)
    }

    func moveExercises(from source: IndexSet, to destination: Int) {
        session.training.exercises.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    NavigationStack {
        TrainingExerciseListView(session: .constant(SessionDraft(training: sampleTrainingDraft)))
    }
}
