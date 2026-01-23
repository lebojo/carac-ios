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

    @Binding var session: SessionDraft

    var body: some View {
        List {
            ForEach(session.training.exercises) { exercise in
                Text(exercise.name)
                    .foregroundStyle(exercise.sets.count > 1 ? .gray : .primary)
            }
            .onMove(perform: moveExercises)
        }
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
        .endSessionAlert(isPresented: $showConfirmation, sessionDraft: session, type: alertType)
        .navigationTitle("Session of \(session.date.formatted(.dateTime.day().month()))")
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
