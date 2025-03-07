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

    @State private var newExercise = Exercise()

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
            }

            Section("Repeat") {
                ForEach(RepeatDay.allCases, id: \.self) { day in
                    if day != .noRepeat {
                        Button {
                            if let index = newExercise.days.firstIndex(of: day.rawValue) {
                                newExercise.days.remove(at: index)
                            } else {
                                newExercise.days.append(day.rawValue)
                            }
                        } label: {
                            HStack {
                                Text("Every \(day.rawValue)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(.foreground)
                                if newExercise.days.contains(day.rawValue) {
                                    Image(systemName: "checkmark.arrow.trianglehead.counterclockwise")
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Create an exercise")
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button("Save now", systemImage: "calendar.badge.plus") {
                    modelContext.insert(newExercise)
                    mainViewState.mainPath.removeLast()
                }
                .buttonStyle(.bordered)
                .padding()

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
