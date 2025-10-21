//
//  ContentView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Query private var trainings: [Training]

    private var todayTrainings: [Training] {
        trainings.filter { $0.repeatDays.contains(RepeatDay.today.rawValue) }.filter { $0.sessions.isEmpty }
    }
    
    private var weekTrainings: [Training] {
        trainings.filter { !$0.repeatDays.contains(RepeatDay.today.rawValue) }
    }

    var body: some View {
        NavigationStack {
            List {
                TodayHomeView(trainings: todayTrainings)

                if !weekTrainings.isEmpty {
                    Section("This week") {
                        WeekHomeView(trainings: weekTrainings)
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
