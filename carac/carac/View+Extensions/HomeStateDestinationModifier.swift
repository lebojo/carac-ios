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
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: MainState.self) { state in
                switch state {
                case .createExercise:
                    CreateAnExerciseView()
                case .globalSettings:
                    GlobalSettingsView()
                }
            }
    }
}
