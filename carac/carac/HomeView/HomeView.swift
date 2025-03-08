//
//  ContentView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var mainViewState: MainViewState

    @Query private var exercises: [Exercise]

    var todayExercises: [Exercise] {
        exercises.filter { $0.days.contains(RepeatDay.today.rawValue) }
    }

    var body: some View {
        NavigationStack(path: $mainViewState.mainPath) {
            TabView {
                List {
                    Section("Today") {
                        TodayHomeView(exercises: todayExercises)
                    }

                    if !exercises.isEmpty {
                        Section("This week") {
                            WeekHomeView(exercises: exercises)
                        }
                    }
                }
                .navigationTitle("Carac Home")
                .tabItem {
                    Label("Carac", systemImage: "house.fill")
                }
                //                .onBoarding(isPresented: exercises.isEmpty) // TODO: Change to UserDefaults

                Text("Waw")
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.xaxis.ascending")
                    }

                GlobalSettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .navigationTitle("Carac Home")
            .toolbar { HomeToolbarView() }
            .homeStateDestination()
            .navigationDestination(for: Session.self, destination: { session in
                SessionView(session: session)
            })
        }
    }

    private func addItem() {
        withAnimation {
//            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(exercises[index])
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Exercise.self, inMemory: true)
        .environmentObject(sampleMainViewState)
}
