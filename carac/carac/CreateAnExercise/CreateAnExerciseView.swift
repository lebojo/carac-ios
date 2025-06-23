//
//  CreateAnExerciseView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftUI

struct CreateAnExerciseView: View {
    @EnvironmentObject var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    @State private var newExercise = Exercise(days: [RepeatDay.today])

    var body: some View {
        NavigationStack {
            Form {
                Section("Carac") {
                    HStack {
                        Text("Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField(text: $newExercise.name) {
                            Text("Curl Series")
                        }
                        .multilineTextAlignment(.trailing)
                    }

                    Toggle("Is repeated", isOn: Binding(get: {
                        !newExercise.days.contains(RepeatDay.noRepeat.rawValue)
                    }, set: { isEnabled in
                        if isEnabled {
                            newExercise.days = [RepeatDay.today.rawValue]
                        } else {
                            newExercise.days = [RepeatDay.noRepeat.rawValue]
                        }
                    }))
                }

                if !newExercise.days.contains(RepeatDay.noRepeat.rawValue) {
                    Section("Repeat") {
                        RepeatDayPicker(newExercise: newExercise)
                    }
                }
            }
            .navigationTitle("Create an exercise")
            .closeButton()
            .animation(.default, value: newExercise.days)
            .bottomButton(title: "Create now", systemName: "calendar.badge.plus", disabled: newExercise.name.isEmpty) {
                modelContext.insert(newExercise)
                mainViewState.selectedState = nil
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateAnExerciseView()
    }
}
