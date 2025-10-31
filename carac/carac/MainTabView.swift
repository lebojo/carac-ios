//
//  MainView.swift
//  carac
//
//  Created by Jordan on 13.03.2025.
//

import SwiftUI

struct MainTabView: View {
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
        //                .onBoarding(isPresented: exercises.isEmpty) // TODO: Change to UserDefaults
    }
}

#Preview {
    MainTabView()
        .environmentObject(sampleMainViewState)
}
