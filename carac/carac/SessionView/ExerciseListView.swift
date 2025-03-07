//
//  ExerciseListView.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import SwiftUI

struct ExerciseListView: View {
    @Bindable var exercise: Exercise

    var body: some View {
        List {
            Section {
                ForEach(exercise.sets.sorted { $0.id < $1.id }) { set in
                    SetView(set: set)
                        .contextMenu {
                            Button(role: .destructive) {
                                if let setIndex = exercise.sets.firstIndex(of: set) {
                                    deleteSets(at: [setIndex])
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete(perform: deleteSets)
            } header: {
                HStack {
                    Text(exercise.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(exercise.sets.count)")
                }
            } footer: {
                HStack {
                    Button {
                        withAnimation {
                            exercise.sets.append(ExerciseSet(
                                id: (exercise.sets.last?.id ?? 0) + 1,
                                reps: exercise.sets.last?.reps ?? 1,
                                weight: exercise.sets.last?.weight ?? 1
                            ))
                        }
                    } label: {
                        Text("Add Set")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .shadow(color: .primary, radius: 5)
        .padding()
    }

    //            .navigationTitle("Test") TODO: Fix crash

    private func deleteSets(at offsets: IndexSet) {
        withAnimation {
            exercise.sets.remove(atOffsets: offsets)
        }
    }
}

#Preview {
    ExerciseListView(exercise: sampleExercise)
}
