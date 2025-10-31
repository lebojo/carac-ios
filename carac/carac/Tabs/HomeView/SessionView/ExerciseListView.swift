//
//  ExerciseListView.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Charts
import SwiftUI

struct ExerciseListView: View {
    @Binding var exercise: ExerciseDraft

    var body: some View {
        List {
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
            }
        })
        .onAppear {
            if exercise.sets.isEmpty {
                exercise.sets.append(ExerciseSetDraft(id: 0))
            }
        }
    }

    private func deleteSets(at offsets: IndexSet) {
        withAnimation {
            exercise.sets.remove(atOffsets: offsets)
        }
    }
}

#Preview {
    ExerciseListView(exercise: .constant(sampleExerciseDraft))
        .padding()
}
