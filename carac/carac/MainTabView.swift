//
//  MainView.swift
//  carac
//
//  Created by Jordan on 13.03.2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var mainViewState: MainViewState

    @State private var navigationTitle = "Carac Home"

    var body: some View {
        NavigationStack(path: $mainViewState.homePath) {
            TabView(selection: $navigationTitle) {
                ExercisesView()
                    .tabItem {
                        Label("Exercises", systemImage: "figure.strengthtraining.traditional")
                    }
                    .tag("Carac exercises")

                HomeView()
                    .tabItem {
                        Label("Carac", systemImage: "house.fill")
                    }
                    .tag("Carac Home")

                Text("TODO")
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.xaxis.ascending")
                    }
                    .tag("Carac teristics")
            }
            .navigationTitle(navigationTitle)
            .toolbar { HomeToolbarView() }
            .homeStateDestination()
            .navigationDestination(for: Exercise.self) { exercise in
                ModifyAnExercise(exercise: exercise)
            }
            .navigationDestination(for: Session.self, destination: { session in
                SessionView(session: session)
            })
            //                .onBoarding(isPresented: exercises.isEmpty) // TODO: Change to UserDefaults
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(sampleMainViewState)
}
