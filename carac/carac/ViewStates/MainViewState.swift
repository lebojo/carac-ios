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

    case createExercise
    case globalSettings
}

class MainViewState: ObservableObject {
    @Published var selectedState: HomeState?
    @Published var selectedExercise: Exercise?
    @Published var selectedSession: Session?

    func backHome() {
        selectedState = nil
    }
}
