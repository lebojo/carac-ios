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
        .animation(.default, value: newExercise.days)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button("Save now", systemImage: "calendar.badge.plus") {
                    modelContext.insert(newExercise)
                    mainViewState.mainPath.removeLast()
                }
                .buttonStyle(.bordered)
                .padding()
                .disabled(newExercise.name.isEmpty)

                Button("Fake exercice", systemImage: "gear") {
                    modelContext.insert(sampleExercise)
                    mainViewState.mainPath.removeLast()
                    mainViewState.mainPath.append(Session(exercises: [sampleExercise]))
                }
            }
            .frame(maxWidth: .infinity)
            .background(.background)
        }
    }
}

#Preview {
    NavigationStack {
        CreateAnExerciseView()
    }
}
