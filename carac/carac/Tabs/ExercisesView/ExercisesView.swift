//
//  ExercisesView.swift
//  carac
//
//  Created by Jordan on 14.03.2025.
//

import SwiftData
import SwiftUI

struct ExercisesView: View {
    @EnvironmentObject var mainViewState: MainViewState

    @Query private var exercises: [Exercise]

    var body: some View {
        List(exercises) { exercise in
            Button {
                mainViewState.homePath.append(exercise)
            } label: {
                HStack {
                    Text(exercise.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                }
            }
        }
        .bottomButton(title: "Create an exercise", systemName: "plus") {
            mainViewState.homePath.append(HomeState.createExercise)
        }
    }
}
