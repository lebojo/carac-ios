//
//  StatisticsView.swift
//  carac
//
//  Created by Jordan on 16.03.2025.
//

import SwiftData
import SwiftUI

struct StatisticsView: View {
    @Query private var exercises: [Exercise]

    var body: some View {
        List {
            if !exercises.isEmpty {
                Section("Global stats") {
                    Text("Total exercises: \(exercises.count)")
                }
            } else {
                ContentUnavailableView("No stats for now", systemImage: "chart.line.downtrend.xyaxis")
            }
        }
    }
}

#Preview {
    StatisticsView()
}
