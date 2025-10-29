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
            .navigationTitle("Create an exercise")
            .closeButton()
            .bottomButton(title: "Create now", systemName: "calendar.badge.plus", disabled: newExercise.name.isEmpty) {
                modelContext.insert(newExercise)
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
