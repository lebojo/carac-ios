//
//  HomeStateDestination.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import Foundation
import SwiftUI

extension View {
    public func homeStateDestination() -> some View {
        modifier(HomeStateDestinationModifier())
    }
}

struct HomeStateDestinationModifier: ViewModifier {
    @EnvironmentObject var mainViewState: MainViewState

    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $mainViewState.selectedState) { state in
                switch state {
                case .createTraining:
                    TrainingCreationView()
                case .globalSettings:
                    GlobalSettingsView()
                }
            }
            .fullScreenCover(item: $mainViewState.selectedExercise) { exercise in
                ModifyAnExercise(exercise: exercise)
            }
            .fullScreenCover(item: $mainViewState.currentSession) { session in
                SessionView(session: session)
            }
    }
}
