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
}

@MainActor
class MainViewState: ObservableObject {
    @Published var selectedState: HomeState?
    @Published var selectedExercise: Exercise?
    @Published var selectedTraining: Training?

    @Published var currentSession: SessionDraft? {
        didSet {
            guard currentSession?.id != oldValue?.id else { return }

            // A session left without `saveSession()` cancels its workout.
            if let currentSession, currentSession.persistedSession == nil {
                workoutManager.start()
            } else {
                workoutManager.cancel()
            }
        }
    }

    @Published var workoutSaveFailed = false

    private let workoutManager = WorkoutManager()

    func saveSession() {
        workoutManager.finish { [weak self] in
            self?.workoutSaveFailed = true
        }
        backHome()
    }

    func backHome() {
        selectedState = nil
        selectedExercise = nil
        selectedTraining = nil
        currentSession = nil
    }
}
