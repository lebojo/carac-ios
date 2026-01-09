//
//  TrainingCreationView.swift
//  carac
//
//  Created by Jordan Chap on 18.10.2025.
//

import SwiftData
import SwiftUI

struct TrainingCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var newTraining = Training("", repeatDays: [RepeatDay.today])

    var body: some View {
        NavigationStack {
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
            .animation(.easeInOut, value: newTraining.exercises)
            .navigationTitle("New training")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create", systemImage: "checkmark") {
                        modelContext.insert(newTraining)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TrainingCreationView()
        .environmentObject(sampleMainViewState)
}
