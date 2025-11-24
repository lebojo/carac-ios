//
//  StatisticsView.swift
//  carac
//
//  Created by Jordan on 16.03.2025.
//

import SwiftData
import SwiftUI

struct StatisticsView: View {
    @Query private var sessions: [Session]
    @Query private var trainings: [Training]
    
    private var todayTrainings: [Training] {
        trainings.filter { $0.repeatDays.contains(RepeatDay.today.rawValue) }.done
    }

    private var todayDoneSessionCount: Int {
        trainings.flatMap(\.sessions).filter { Calendar.current.isDateInToday($0.date) }.count
    }

    private var exerciseDoneTodayCount: Int {
        trainings.flatMap(\.sessions).filter { Calendar.current.isDateInToday($0.date) }.flatMap(\.training.exercises).count
    }

    private var totalWeightPulled: Double {
        trainings.flatMap(\.exercises).flatMap(\.sets).reduce(0.0) { total, set in
            total + set.weight * Double(set.reps)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if !trainings.isEmpty {
                    Section("Hall of glory") {
                        VStack {
                            Image(systemName: "trophy")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .frame(maxWidth: .infinity, alignment: .center)

                            Text("Total weight pulled: **\(totalWeightPulled.formatted()) kg**")
                        }
                    }
                    
                    Section("Today stats") {
                        Label("Total sessions: **\(todayDoneSessionCount)**", systemImage: "figure.run")
                        Label("Total exercices: **\(exerciseDoneTodayCount)**", systemImage: "dumbbell")
                    }
                    
                    Section("Global stats") {
                        Label("Total sessions: **\(trainings.done.flatMap(\.sessions).count)**", systemImage: "figure.run")
                        Label("Total exercices: **\(trainings.done.flatMap(\.exercises).count)**", systemImage: "dumbbell")
                    }
                } else {
                    ContentUnavailableView("No stats for now", systemImage: "chart.line.downtrend.xyaxis")
                }
            }
            .navigationTitle("Carac teristics")
            .toolbar { HomeToolbarView() }
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
