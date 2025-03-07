//
//  MainViewState.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import Foundation
import SwiftUI

enum MainState: Hashable {
    case createExercise
}

class MainViewState: ObservableObject {
    @Published var mainPath = NavigationPath()
}
