//
//  CreateAnExerciseView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftUI

struct CreateAnExerciseSheetView: View {
    @EnvironmentObject var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    @State private var newExercise = Exercise()
    
    @Binding var isPresented: Bool
    var onCreated: ((Exercise) -> Void)? = nil

    var body: some View {
        NavigationView {
            List {
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
                
                Section("Type & Equipment") {
                    Picker("Exercise Type", selection: $newExercise.exerciseType) {
                        ForEach(ExerciseType.allCases) { type in
                            Label(type.title, systemImage: type.systemImage)
                                .tag(type.rawValue)
                        }
                    }
                    
                    Picker("Equipment", selection: $newExercise.equipment) {
                        ForEach(EquipmentType.allCases) { eq in
                            Label(eq.title, systemImage: eq.systemImage)
                                .tag(eq.rawValue)
                        }
                    }
                }
                
                if newExercise.exerciseType == ExerciseType.strength.rawValue || newExercise.exerciseType == ExerciseType.calisthenics.rawValue {
                    Section {
                        VStack {
                            Stepper("Wheight step: **\(newExercise.weightSteps.formatted())**", value: $newExercise.weightSteps, step: 0.1)
                            
                            Picker("Picker template", selection: $newExercise.weightSteps) {
                                ForEach([1, 2.5, 5, 10], id: \.self) { num in
                                    Text(num, format: .number.precision(.fractionLength(1)))
                                        .tag(num)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    } footer: {
                        Text("Wheight step is used to precisely measure the weight of the exercise.")
                    }
                }
            }
            .navigationTitle("Create an exercise")
            .closeButton()
            .bottomButton(title: "Create now", systemName: "calendar.badge.plus", disabled: newExercise.name.isEmpty) {
                modelContext.insert(newExercise)
                onCreated?(newExercise)
                isPresented = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateAnExerciseSheetView(isPresented: .constant(true))
    }
}
