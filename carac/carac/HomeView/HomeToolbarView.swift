//
//  HomeToolbarView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct HomeToolbarView: View {
    @EnvironmentObject var mainViewState: MainViewState

    var body: some View {
        Button {
            mainViewState.mainPath.append(MainState.createExercise)
        } label: {
            Label("Create an exercise", systemImage: "plus")
        }
    }
}
