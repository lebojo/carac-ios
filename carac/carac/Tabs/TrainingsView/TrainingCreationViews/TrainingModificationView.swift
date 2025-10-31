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

    @Bindable var training: Training

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Name")
                        TextField(text: $training.title) {
                            Text("Top body training")
                        }
                        .multilineTextAlignment(.trailing)
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
            .closeButton()
            .navigationTitle(training.title)
            .animation(.easeInOut, value: training.exercises)
            .bottomButton(title: "Modify now", systemName: "calendar.badge.plus", disabled: training.exercises.isEmpty || training.title.isEmpty) {
                try! modelContext.save()

                mainViewState.selectedState = nil
            }
        }
    }
}
