//
//  WeekHomeView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct WeekSectionHomeView: View {
    let emptyDays: Set<RepeatDay>
    let trainingDays: [RepeatDay: String]

    init(trainings: [Training]) {
        trainingDays = Dictionary(uniqueKeysWithValues: RepeatDay.allCases.compactMap { day in
            let titles = trainings
                .filter { $0.repeatDays.contains(day.rawValue) }
                .map(\.title)
                .joined(separator: ", ")

            return titles.isEmpty ? nil : (day, titles)
        })

        emptyDays = Set(RepeatDay.allCases).subtracting(trainingDays.keys)
    }

    var body: some View {
        Section("This week") {
            ForEach(RepeatDay.allCases, id: \.self) { day in
                if let titles = trainingDays[day] {
                    HStack {
                        Text(day.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(titles)
                            .lineLimit(1)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                    .bold(day.isToday)
                }
            }
        }
    }
}

#Preview {
    WeekSectionHomeView(trainings: [sampleTraining, sampleTraining])
}
