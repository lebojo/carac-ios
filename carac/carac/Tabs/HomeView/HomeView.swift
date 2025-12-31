//
//  ContentView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var mainViewState: MainViewState

    @Query(filter: #Predicate<Training> { training in training.sessions.isEmpty })
    private var trainings: [Training]

    private var todayTrainings: [Training] {
        trainings.filter { $0.repeatDays.contains(RepeatDay.today.rawValue) }
    }

    var body: some View {
        NavigationStack {
            List {
                TodayHomeView(trainings: todayTrainings)

                Section {
                    Menu("Start another day training") {
                        ForEach(trainings) { training in
                            Button(training.title + " (\(training.repeatDaysStringified))") {
                                let draft = SessionDraft(training: TrainingDraft(from: training))
                                mainViewState.currentSession = draft
                            }
                        }
                    }
                }

                if !trainings.isEmpty {
                    Section("This week") {
                        WeekHomeView(trainings: trainings)
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
