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

                Toggle("Is repeated", isOn: Binding(get: {
                    !exercise.days.contains(RepeatDay.noRepeat.rawValue)
                }, set: { isEnabled in
                    if isEnabled {
                        exercise.days = [RepeatDay.today.rawValue]
                    } else {
                        exercise.days = [RepeatDay.noRepeat.rawValue]
                    }
                }))
            }

            if !exercise.days.contains(RepeatDay.noRepeat.rawValue) {
                Section("Repeat") {
                    RepeatDayPicker(newExercise: exercise)
                }
            }
        }
        .navigationTitle("Modify the exercise")
        .animation(.default, value: exercise.days)
        .bottomButton(title: "Update now", systemName: "pencil.and.outline", disabled: exercise.name.isEmpty) {
            do {
                try modelContext.save()
            } catch {
                print("Can't update exercise: \(error)")
            }
            mainViewState.homePath.removeLast()
        }
    }
}
