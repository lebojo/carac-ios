//
//  ExerciseDraftView.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import SwiftData
import SwiftUI

struct ExerciseDraftView: View {
    @Query private var sessions: [Session]

    @EnvironmentObject var mainViewState: MainViewState

    @State private var lastExerciseSet: ExerciseSet?

    @Binding var exercise: ExerciseDraft

    var body: some View {
        List {
            if let lastExerciseSet {
                Section("Last time best") {
                    VStack(alignment: .leading, spacing: 20) {
                        Label("Weight: \(lastExerciseSet.weight.maxDigits(2))kg", systemImage: "dumbbell.fill")

                        Label("Reps: \(lastExerciseSet.reps)", systemImage: "arrow.triangle.2.circlepath")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .cardStyle()
                    .listRowSeparator(.hidden)
                }
                .opacity(0.5)
            }

            Section {
                ForEach($exercise.sets.sorted { $0.id < $1.id }) { set in
                    SetView(set: set, exerciseWeightStep: exercise.weightSteps)
                        .contextMenu {
                            Button(role: .destructive) {
                                if let setIndex = exercise.sets.firstIndex(of: set.wrappedValue) {
                                    deleteSets(at: [setIndex])
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .listRowSeparator(.hidden)
                }
                .onDelete(perform: deleteSets)
            } header: {
                Text("Sets: \(exercise.sets.count)")
            } footer: {
                AddSetsButton(exercise: $exercise)
                    .listRowSeparator(.hidden)
            }
        }
        .navigationTitle(exercise.name)
        .scrollIndicators(.never)
        .listStyle(.plain)
        .task {
            setLastBestSetIfAvailable()

            if exercise.sets.isEmpty {
                exercise.sets.append(ExerciseSetDraft(id: 0, weight: lastExerciseSet?.weight ?? exercise.weightSteps))
            }
        }
    }

    private func deleteSets(at offsets: IndexSet) {
        withAnimation {
            exercise.sets.remove(atOffsets: offsets)
        }
    }

    private func setLastBestSetIfAvailable() {
        let lastSession = sessions
            .filter { $0.persistentModelID != mainViewState.currentSession?.persistedSession?.persistentModelID }
            .filter { session in
                session.training.exercises.contains { $0.name == exercise.name }
            }
            .max(by: { $0.date < $1.date })

        if let sets = lastSession?.training.exercises.first(where: { $0.name == exercise.name })?.sets.sorted(by: { $0.weight > $1.weight }) {
            lastExerciseSet = sets.count > 1 ? sets[1] : sets.first
        } else {
            lastExerciseSet = nil
        }
    }
}

#Preview {
    ExerciseDraftView(exercise: .constant(sampleExerciseDraft))
        .padding()
}
