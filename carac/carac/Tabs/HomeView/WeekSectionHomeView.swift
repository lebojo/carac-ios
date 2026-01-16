//
//  WeekSectionHomeView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct WeekSectionHomeView: View {
    let emptyDays: Set<RepeatDay>
    let trainingDays: [RepeatDay: [Training]]

    init(trainings: [Training]) {
        trainingDays = Dictionary(uniqueKeysWithValues: RepeatDay.allCases.compactMap { day in
            let dayTraining = trainings
                .filter { $0.repeatDays.contains(day.rawValue) }

            return dayTraining.isEmpty ? nil : (day, dayTraining)
        })

        emptyDays = Set(RepeatDay.allCases).subtracting(trainingDays.keys).filter { $0 != .noRepeat }
    }

    var body: some View {
        Section("This week") {
            ForEach(RepeatDay.allCases.filter { $0 != .noRepeat }, id: \.self) { day in
                if let trainings = trainingDays[day] {
                    HStack {
                        Text(day.title)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        MenuButtonView(trainings: trainings)
                    }
                    .bold(day.isToday)
                }
            }

            if !emptyDays.isEmpty {
                Text(emptyDays.map(\.title).joined(separator: ", "))
                    .italic()
            }
        }
    }
}

struct MenuButtonView: View {
    @EnvironmentObject private var mainViewState: MainViewState

    let trainings: [Training]

    var body: some View {
        if trainings.count > 1 {
            Menu("Start here") {
                ForEach(trainings, id: \.title) { training in
                    trainingButton(training)
                }
            }
        } else if let first = trainings.first {
            trainingButton(first)
        }
    }

    func trainingButton(_ training: Training) -> some View {
        Button(training.title) {
            let draft = SessionDraft(training: TrainingDraft(from: training))
            mainViewState.currentSession = draft
        }
    }
}

#Preview {
    WeekSectionHomeView(trainings: [sampleTraining, sampleTraining])
}
