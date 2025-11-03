//
//  TrainingExerciseListView.swift
//  carac
//
//  Created by Jordan Chap on 03.11.2025.
//

import SwiftUI

struct TrainingExerciseListView: View {
    @State private var showConfirmation: Bool = false

    @Binding var session: SessionDraft

    var body: some View {
        List {
            ForEach(session.training.exercises) { exercise in
                Text(exercise.name)
                    .foregroundStyle(exercise.sets.count > 1 ? .gray : .primary)
            }
            .onMove(perform: moveExercises)
        }
        .closeButton()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                showConfirmation.toggle()
            } label: {
                Label("Save now", systemImage: "opticaldisc")
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .endSessionAlert(isPresented: $showConfirmation, sessionDraft: session)
        .navigationTitle("Session of \(session.date.formatted(.dateTime.day().month()))")
    }

    func moveExercises(from source: IndexSet, to destination: Int) {
        session.training.exercises.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    TrainingExerciseListView(session: .constant(SessionDraft(training: sampleTrainingDraft)))
}
