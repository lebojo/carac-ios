//
//  SessionView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftUI

struct SessionView: View {
    @EnvironmentObject private var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    @State private var showConfirmation = false
    @State private var session: SessionDraft

    init(session: SessionDraft) {
        self._session = State(initialValue: session)
    }

    var body: some View {
        TabView {
            NavigationStack {
                TrainingExerciseListView(session: $session)
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }

            TabView {
                ForEach($session.training.exercises) { exercise in
                    ExerciseDraftView(exercise: exercise)
                }
            }
            .tabViewStyle(.page)
            .tabItem {
                Label("Exercises", systemImage: "figure.walk")
            }

            VStack {
                SessionChart(weights: session.training.exercises.flatMap { $0.sets.map(\.weight) },
                             reps: session.training.exercises.flatMap { $0.sets.map(\.reps) })
                    .padding()
                    .frame(height: 150)
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar")
            }
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

#Preview {
    NavigationStack {
        SessionView(
            session: SessionDraft(training: sampleTrainingDraft)
        )
        .navigationTitle("Dimanche")
    }
}
