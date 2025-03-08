//
//  ExerciseListView.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Charts
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
                        .listRowSeparator(.hidden)
                }
                .onDelete(perform: deleteSets)
            } header: {
                HStack {
                    Text(exercise.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(exercise.sets.count)")
                }
            } footer: {
                AddSetsButton(exercise: exercise)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .background()
    }

    private func deleteSets(at offsets: IndexSet) {
        withAnimation {
            exercise.sets.remove(atOffsets: offsets)
        }
    }
}

#Preview {
    ExerciseListView(exercise: sampleExercise)
        .padding()
}
