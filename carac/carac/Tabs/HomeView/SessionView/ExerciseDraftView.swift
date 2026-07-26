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
                        if exercise.exerciseType == ExerciseType.cardio.rawValue {
                            Label("Duration: \((lastExerciseSet.duration ?? 15.0).maxDigits(1)) min", systemImage: "clock.fill")
                            Label("Distance: \((lastExerciseSet.distance ?? 3.0).maxDigits(2)) km", systemImage: "road.lanes")
                        } else {
                            Label("Weight: \(lastExerciseSet.weight.maxDigits(2))kg", systemImage: "dumbbell.fill")
                            Label("Reps: \(lastExerciseSet.reps)", systemImage: "arrow.triangle.2.circlepath")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .cardStyle()
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .opacity(0.5)
            }

            Section {
                ForEach($exercise.sets.sorted { $0.id < $1.id }) { set in
                    SetView(set: set, exerciseWeightStep: exercise.weightSteps, exerciseType: exercise.exerciseType)
                        .contextMenu {
                            Button(role: .destructive) {
                                if let setIndex = exercise.sets.firstIndex(of: set.wrappedValue) {
                                    deleteSets(at: [setIndex])
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .disabled(exercise.sets.count <= 1)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteSets)
            } header: {
                Text("Sets: \(exercise.sets.count)")
            } footer: {
                AddSetsButton(exercise: $exercise)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .caracListStyle()
        .navigationTitle(exercise.name)
        .scrollIndicators(.never)
        .listStyle(.plain)
        .task {
            setLastBestSetIfAvailable()

            if exercise.sets.isEmpty {
                if exercise.exerciseType == ExerciseType.cardio.rawValue {
                    exercise.sets.append(ExerciseSetDraft(id: 0, duration: lastExerciseSet?.duration ?? 15.0, distance: lastExerciseSet?.distance ?? 3.0))
                } else {
                    exercise.sets.append(ExerciseSetDraft(id: 0, weight: lastExerciseSet?.weight ?? exercise.weightSteps))
                }
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

        if let ex = lastSession?.training.exercises.first(where: { $0.name == exercise.name }) {
            let sortedSets: [ExerciseSet]
            if exercise.exerciseType == ExerciseType.cardio.rawValue {
                sortedSets = ex.sets.sorted(by: { ($0.distance ?? 0) > ($1.distance ?? 0) })
            } else {
                sortedSets = ex.sets.sorted(by: { $0.weight > $1.weight })
            }
            lastExerciseSet = sortedSets.count > 1 ? sortedSets[1] : sortedSets.first
        } else {
            lastExerciseSet = nil
        }
    }
}

#Preview {
    ExerciseDraftView(exercise: .constant(sampleExerciseDraft))
        .padding()
}
