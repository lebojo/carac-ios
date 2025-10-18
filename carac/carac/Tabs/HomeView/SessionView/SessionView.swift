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

    @Bindable var session: Session

    var body: some View {
        TabView {
            NavigationStack {
                ForEach(session.training.exercises) { exercise in
                    ExerciseListView(exercise: exercise)
                }

//                VStack {
//                    SessionChart(weights: session.training.exercises.flatMap { $0.sets.map(\.weight) },
//                                 reps: session.training.exercises.flatMap { $0.sets.map(\.reps) })
//                    .padding()
//                    .frame(height: 150)
//                }
            }
            .navigationTitle("Session \(session.date, style: .date)")
            .closeButton()
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
                message: Text("Terminate the session now and save all your stats ?"),
                primaryButton: .cancel(),
                secondaryButton: .default(Text("Save"), action: {
                    try! modelContext.save()
                    mainViewState.selectedState = nil
                })
            )
        }
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
