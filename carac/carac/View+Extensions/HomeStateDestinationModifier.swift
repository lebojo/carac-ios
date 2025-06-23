//
//  HomeStateDestination.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import Foundation
import SwiftUI

public extension View {
    func homeStateDestination() -> some View {
        modifier(HomeStateDestinationModifier())
    }
}

struct HomeStateDestinationModifier: ViewModifier {
    @EnvironmentObject var mainViewState: MainViewState

    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $mainViewState.selectedState) { state in
                switch state {
                case .createExercise:
                    CreateAnExerciseView()
                case .globalSettings:
                    GlobalSettingsView()
                }
            }
            .fullScreenCover(item: $mainViewState.selectedExercise) { exercise in
                ModifyAnExercise(exercise: exercise)
            }
            .fullScreenCover(item: $mainViewState.selectedSession) { session in
                SessionView(session: session)
            }
    }
}
