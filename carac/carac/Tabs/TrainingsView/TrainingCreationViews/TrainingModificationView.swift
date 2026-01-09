//
//  TrainingModificationView.swift
//  carac
//
//  Created by Jordan Chap on 18.10.2025.
//

import SwiftData
import SwiftUI

struct TrainingModificationView: View {
    @EnvironmentObject var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    @Query private var allTrainings: [Training]

    @Bindable var training: Training

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Name")
                    TextField(text: $training.title) {
                        Text("Top body training")
                    }
                    .multilineTextAlignment(.trailing)
                    .onChange(of: training.title) { oldValue, newValue in
                        for training in allTrainings {
                            guard training.title == oldValue else { continue }

                            training.title = newValue
                        }
                    }
                }

                NavigationLink(
                    "Training days",
                    destination: RepeatDayPicker(newTraining: training)
                )
            } header: {
                Text("Main info")
            } footer: {
                if !training.title.isEmpty
                    && !training.repeatDays.isEmpty
                {
                    Text(
                        "\(training.title) should be done every \(training.repeatDays.joined(separator: ", "))"
                    )
                }
            }

            ExercisesGridSection(trainingExercises: $training.exercises)
        }
        .navigationTitle(training.title)
        .animation(.easeInOut, value: training.exercises)
    }
}
