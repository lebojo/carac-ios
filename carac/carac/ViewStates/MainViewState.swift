//
//  MainViewState.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import Foundation
import SwiftUI

enum HomeState: String, Identifiable {
    var id: String { rawValue }

    case createTraining
    case globalSettings
}

class MainViewState: ObservableObject {
    @Published var selectedState: HomeState?
    @Published var selectedExercise: Exercise?
    @Published var selectedTraining: Training?

    @Published var currentSession: SessionDraft?

    func backHome() {
        selectedState = nil
        selectedExercise = nil
        selectedTraining = nil
        currentSession = nil
    }
}
