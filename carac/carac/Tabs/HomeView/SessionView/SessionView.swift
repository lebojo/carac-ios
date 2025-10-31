//
//  SessionView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftData
import SwiftUI

struct SessionView: View {
    @EnvironmentObject private var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    @State private var showConfirmation = false
    @State private var session: Session

    init(session: Session) {
        self._session = State(initialValue: session)
    }

    var body: some View {
        TabView {
            NavigationView {
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
                .navigationTitle("Session of \(session.date.formatted(.dateTime.day().month()))")
            }

            ForEach($session.training.exercises) { exercise in
                NavigationView {
                    ExerciseListView(exercise: exercise)
                }
            }

//                VStack {
//                    SessionChart(weights: session.training.exercises.flatMap { $0.sets.map(\.weight) },
//                                 reps: session.training.exercises.flatMap { $0.sets.map(\.reps) })
//                    .padding()
//                    .frame(height: 150)
//                }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .safeAreaInset(edge: .bottom) {
            Button {
                showConfirmation.toggle()
            } label: {
                Label("Save now", systemImage: "opticaldisc")
            }
            .buttonStyle(.bordered)
        }
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
                        modelContext.insert(session)
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
            session: Session(training: sampleTraining)
        )
        .navigationTitle("Dimanche")
    }
}
