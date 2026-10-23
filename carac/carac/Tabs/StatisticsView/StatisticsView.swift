//
//  StatisticsView.swift
//  carac
//
//  Created by Jordan on 16.03.2025.
//

import SwiftData
import SwiftUI

struct StatisticsView: View {
    @StateObject private var statisticsViewState: StatisticsViewState = .init()

    @Query private var trainings: [Training]

    @State private var currentDate: Date = .now

    private var currentDateDoneSession: [Session] {
        trainings.flatMap { $0.sessions ?? [] }.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day) }
    }

    private var currentDateDoneExercises: [Exercise] {
        trainings.flatMap { $0.sessions ?? [] }.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day) }.flatMap { $0.training?.exercises ?? [] }
    }

    private var totalWeightPulled: Double {
        trainings.flatMap { $0.exercises ?? [] }.flatMap { $0.sets ?? [] }.reduce(0.0) { total, set in
            total + set.weight * Double(set.reps)
        }
    }

    private var currentDateTotalWeightPulled: Double {
        currentDateDoneSession.reduce(0) { $0 + $1.totalWeightPulled }
    }

    var body: some View {
        NavigationStack(path: $statisticsViewState.navPath) {
            List {
                if !trainings.isEmpty {
                    StatisticsCalendarView(selectedDate: $currentDate)
                        .environmentObject(statisticsViewState)

                    Section("Today stats") {
                        Label("Total pulled: **\(currentDateTotalWeightPulled.maxDigits())**", systemImage: "trophy")
                        Label("Total sessions: **\(currentDateDoneSession.count)**", systemImage: "figure.run")
                        Label("Total exercices: **\(currentDateDoneExercises.count)**", systemImage: "dumbbell")
                    }

                    Section("Global stats") {
                        HallOfGloryView(totalWeightPulled: totalWeightPulled)
                            .padding()
                            .listRowSeparator(.hidden)

                        Label("Total sessions: **\(trainings.done.flatMap { $0.sessions ?? [] }.count)**", systemImage: "figure.run")
                        Label("Total exercices: **\(trainings.done.flatMap { $0.exercises ?? [] }.count)**", systemImage: "dumbbell")

                        ForEach(trainings.templates, id: \.persistentModelID) { training in
                            ChevronRowButton(title: training.title) {
                                statisticsViewState.navPath.append(training)
                            }
                        }
                    }

                } else {
                    ContentUnavailableView("No stats for now", systemImage: "chart.line.downtrend.xyaxis")
                }
            }
            .caracListStyle()
            .navigationTitle("Carac teristics")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    DataBackupMenu()
                }
            }
            .navigationDestination(for: Training.self) { training in
                StatisticsTrainingView(trainingTitle: training.title, currentSession: nil)
            }
        }
    }
}

extension [Training] {
    var done: [Training] {
        self.filter { !$0.isTemplate }
    }

    var templates: [Training] {
        self.filter(\.isTemplate)
    }
}
