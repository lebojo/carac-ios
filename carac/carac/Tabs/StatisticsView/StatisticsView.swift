//
//  StatisticsView.swift
//  carac
//
//  Created by Jordan on 16.03.2025.
//

import SwiftData
import SwiftUI

struct StatisticsView: View {
    @Query private var trainings: [Training]
    @Query private var sessions: [Session]
    
    private var todayTrainings: [Training] {
        trainings.filter { $0.repeatDays.contains(RepeatDay.today.rawValue) }.filter { $0.sessions.isEmpty }
    }
    
    private var exceptEmptyExercices: [Training] {
        trainings.filter(\.sessions.isEmpty)
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
                            Text("Total weight pulled: \(trainings.flatMap(\.exercises).flatMap(\.sets).map(\.weight).reduce(0.0, +)) kg")
                        }
                    }
                    
                    Section("Today stats") {
                        Label("Total sessions: \(todayTrainings.flatMap(\.sessions).count)", systemImage: "trophy")
                        Label("Total trainings: \(todayTrainings.count)", systemImage: "figure.run")
                        Label("Total exercices: \(todayTrainings.flatMap(\.exercises).count)", systemImage: "dumbbell")
                    }
                    
                    Section("Global stats") {
                        Label("Total sessions: \(sessions.count)", systemImage: "trophy")
                        Label("Total trainings: \(trainings.count)", systemImage: "figure.run")
                        Label("Total exercices: \(trainings.flatMap(\.exercises).count)", systemImage: "dumbbell")
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
