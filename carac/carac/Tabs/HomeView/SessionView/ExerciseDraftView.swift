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
                    VStack(spacing: 20) {
                        Stepper(value: .constant(lastExerciseSet.weight), in: 0 ... 0) {
                            Label("Weight: \(lastExerciseSet.weight.formatted())kg", systemImage: "dumbbell.fill")
                        }
                        .disabled(true)
                        
                        Stepper(value: .constant(lastExerciseSet.reps), in: 0 ... 0) {
                            Label("Reps: \(lastExerciseSet.reps)", systemImage: "arrow.triangle.2.circlepath")
                        }
                        .disabled(true)
                    }
                    .cardStyle()
                    .opacity(0.8)
                }
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
        .listStyle(.plain)
        .background()
        .safeAreaInset(edge: .top, content: {
            HStack {
                Text(exercise.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .lineLimit(2, reservesSpace: true)
            }
        })
        .onAppear {
            if exercise.sets.isEmpty {
                exercise.sets.append(ExerciseSetDraft(id: 0, weight: exercise.weightSteps))
            }
            let lastWeekSession = sessions.first { session in
                if let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: session.date) {
                    if let sessionDate = mainViewState.currentSession?.date, Calendar.current.isDate(sessionDate, inSameDayAs: lastWeekDate) {
                        return true
                    }
                }
                return false
            }
            lastExerciseSet = lastWeekSession?.training.exercises.first(where: { $0.name == exercise.name })?.sets.sorted { $0.weight > $1.weight }.dropFirst().first
        }
    }

    private func deleteSets(at offsets: IndexSet) {
        withAnimation {
            exercise.sets.remove(atOffsets: offsets)
        }
    }
}

#Preview {
    ExerciseDraftView(exercise: .constant(sampleExerciseDraft))
        .padding()
}
