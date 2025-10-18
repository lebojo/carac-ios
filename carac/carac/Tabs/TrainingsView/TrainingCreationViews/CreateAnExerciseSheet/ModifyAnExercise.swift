//
//  ModifyAnExercise.swift
//  carac
//
//  Created by Jordan on 16.03.2025.
//

import SwiftData
import SwiftUI

struct ModifyAnExercise: View {
    @EnvironmentObject var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    @Bindable var exercise: Exercise

    var body: some View {
        NavigationStack {
            Form {
                Section("Carac") {
                    HStack {
                        Text("Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField(text: $exercise.name) {
                            Text("Curl Series")
                        }
                        .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("Modify the exercise")
            .bottomButton(title: "Update now", systemName: "pencil.and.outline", disabled: exercise.name.isEmpty) {
                do {
                    try modelContext.save()
                } catch {
                    print("Can't update exercise: \(error)")
                }
                mainViewState.selectedExercise = nil
            }
        }
    }
}
