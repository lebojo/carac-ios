//
//  MainView.swift
//  carac
//
//  Created by Jordan on 13.03.2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var mainViewState: MainViewState

    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            TrainingsView()
                .tabItem {
                    Label("Trainings", systemImage: "figure.strengthtraining.traditional")
                }
                .tag(0)

            HomeView()
                .tabItem {
                    Label("Carac", systemImage: "house.fill")
                }
                .tag(1)

            StatisticsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.xaxis.ascending")
                }
                .tag(2)
        }
        .sideBarAdaptableIfAvailable()
        .homeStateDestination()
        .onBoarding(isPresented: $isFirstTime)
        .alert("Workout not saved", isPresented: $mainViewState.workoutSaveFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your session is saved in Carac, but the workout could not be recorded in Apple Fitness.")
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(sampleMainViewState)
}
