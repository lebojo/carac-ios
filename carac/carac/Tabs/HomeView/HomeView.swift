//
//  ContentView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Query private var exercises: [Exercise]

    var todayExercises: [Exercise] {
        exercises.filter { $0.days.contains(RepeatDay.today.rawValue) }
    }

    var body: some View {
        NavigationStack {
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
            .toolbar { HomeToolbarView() }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .modelContainer(for: Exercise.self, inMemory: true)
            .environmentObject(sampleMainViewState)
    }
}
