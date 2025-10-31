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
                .navigationTitle("Session of \(session.date.formatted(.dateTime.day().month()))")
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }

            TabView {
                ForEach($session.training.exercises) { exercise in
                    ExerciseListView(exercise: exercise)
                }
            }
            .tabViewStyle(.page)
            .tabItem {
                Label("Exercises", systemImage: "figure.walk")
            }

//                VStack {
//                    SessionChart(weights: session.training.exercises.flatMap { $0.sets.map(\.weight) },
//                                 reps: session.training.exercises.flatMap { $0.sets.map(\.reps) })
//                    .padding()
//                    .frame(height: 150)
//                }
        }
//        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .alert(isPresented: $showConfirmation) {
            Alert(
                title: Text("End session"),
                message: Text(
                    "Terminate the session now and save all your stats ?"
                ),
                primaryButton: .cancel(),
                secondaryButton: .default(
                    Text("Save"),
                    action: {
                        let sessionSave = Session(from: session)
                        modelContext.insert(sessionSave)
                        do {
                            try modelContext.save()
                            mainViewState.currentSession = nil
                        } catch {
                            print("Failed to save session")
                        }
                    }
                )
            )
        }
    }

    func moveExercises(from source: IndexSet, to destination: Int) {
        session.training.exercises.move(fromOffsets: source, toOffset: destination)
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
