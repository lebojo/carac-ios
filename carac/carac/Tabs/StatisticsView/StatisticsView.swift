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
        trainings.flatMap(\.sessions).filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day) }
    }

    private var currentDateDoneExercises: [Exercise] {
        trainings.flatMap(\.sessions).filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day) }.flatMap(\.training.exercises)
    }

    private var totalWeightPulled: Double {
        trainings.flatMap(\.exercises).flatMap(\.sets).reduce(0.0) { total, set in
            total + set.weight * Double(set.reps)
        }
    }

    private var currentDateTotalWeightPulled: Double {
        currentDateDoneSession.reduce(0) { $0 + $1.totalWeightPulled }
    }

    private var singleTrainings: [Training] {
        trainings.filter { $0.sessions.isEmpty }
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

                        Label("Total sessions: **\(trainings.done.flatMap(\.sessions).count)**", systemImage: "figure.run")
                        Label("Total exercices: **\(trainings.done.flatMap(\.exercises).count)**", systemImage: "dumbbell")

                        ForEach(singleTrainings, id: \.persistentModelID) { training in
                            Button {
                                statisticsViewState.navPath.append(training)
                            } label: {
                                HStack {
                                    Text(training.title)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                    }

                } else {
                    ContentUnavailableView("No stats for now", systemImage: "chart.line.downtrend.xyaxis")
                }
            }
            .navigationTitle("Carac teristics")
            .toolbar { HomeToolbarView() }
            .navigationDestination(for: Date.self) { date in
                StatisticsDateView(date: date)
            }
        }
    }
}

extension [Training] {
    var done: [Training] {
        self.filter { !$0.sessions.isEmpty }
    }

    var templates: [Training] {
        self.filter { $0.sessions.isEmpty }
    }
}
