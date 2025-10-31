//
//  TrainingCreationView.swift
//  carac
//
//  Created by Jordan Chap on 18.10.2025.
//

import SwiftData
import SwiftUI

struct TrainingCreationView: View {
    @EnvironmentObject var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    @State private var newTraining = Training("", repeatDays: [RepeatDay.today])

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Name")
                        TextField(text: $newTraining.title) {
                            Text("Top body training")
                        }
                        .multilineTextAlignment(.trailing)
                    }

                    NavigationLink(
                        "Training days",
                        destination: RepeatDayPicker(newTraining: newTraining)
                    )
                } header: {
                    Text("Main info")
                } footer: {
                    if !newTraining.title.isEmpty
                        && !newTraining.repeatDays.isEmpty
                    {
                        Text(
                            "\(newTraining.title) should be done every \(newTraining.repeatDays.joined(separator: ", "))"
                        )
                    }
                }

                ExercisesGridSection(trainingExercises: $newTraining.exercises)

            }
            .closeButton()
            .navigationTitle("New training")
            .animation(.easeInOut, value: newTraining.exercises)
            .bottomButton(title: "Create now", systemName: "calendar.badge.plus", disabled: newTraining.exercises.isEmpty || newTraining.title.isEmpty) {
                modelContext.insert(newTraining)

                mainViewState.selectedState = nil
            }
        }
    }
}



#Preview {
    TrainingCreationView()
        .environmentObject(sampleMainViewState)
}
