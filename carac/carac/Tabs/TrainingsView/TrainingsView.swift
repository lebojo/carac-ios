//
//  ExercisesView.swift
//  carac
//
//  Created by Jordan on 14.03.2025.
//

import SwiftData
import SwiftUI

struct TrainingsView: View {
    @EnvironmentObject var mainViewState: MainViewState

    @Query private var trainings: [Training]

    var body: some View {
        NavigationStack {
            List {
                ForEach(trainings, id: \.persistentModelID) { training in
                    Button {
                        mainViewState.selectedTraining = training
                    } label: {
                        HStack {
                            Text(training.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            .bottomButton(title: "Create an training", systemName: "plus") {
                mainViewState.selectedState = .createTraining
            }
            .navigationTitle("Carac Training\(trainings.count > 1 ? "s" : "")")
            .toolbar { HomeToolbarView() }
        }
    }
}
