//
//  WeekHomeView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct WeekHomeView: View {
    let exercises: [Exercise]

    var body: some View {
        ForEach(RepeatDay.allCases, id: \.self) { day in
            HStack {
                Text(day.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(exercises.filter { $0.days.contains(day.rawValue) }.map(\.name).joined(separator: ", "))
                    .lineLimit(1)
                    .italic()
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    WeekHomeView(exercises: [sampleExercise, sampleExercise])
}
