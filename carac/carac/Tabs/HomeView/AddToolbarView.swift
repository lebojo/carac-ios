//
//  SettingsToolbarView.swift
//  carac
//
//  Created by Killian Mathias on 22/07/2026.
//

import SwiftUI

struct AddToolbarView: ToolbarContent {
    @Binding var isShowingAddExerciseSheet: Bool
    @Binding var isShowingAddTrainingSheet: Bool
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    isShowingAddTrainingSheet = true
                } label: {
                    Label("Add Training", systemImage: "figure.strengthtraining.traditional")
                }
                Button {
                    isShowingAddExerciseSheet = true
                } label: {
                    Label("Add Exercice", systemImage: "dumbbell.fill")
                }

            } label: {
                Label("Add", systemImage: "plus")
            }
        }
    }
}

#Preview {
    SettingsToolbarView()
}
