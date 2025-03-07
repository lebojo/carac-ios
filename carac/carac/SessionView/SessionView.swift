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
            ForEach(session.exercises) { exercise in
                ExerciseListView(exercise: exercise)
            }
        }
        .tabViewStyle(.page)
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
                    mainViewState.mainPath.removeLast()
                })
            )
        }
    }
}

#Preview {
    NavigationStack {
        SessionView(session:
            Session(exercises:
                [Exercise(name: "Abdos au sol", days: [RepeatDay.today]),
                 Exercise(name: "Curl des biceps", days: [RepeatDay.today])]))
            .navigationTitle("Dimanche")
    }
}
