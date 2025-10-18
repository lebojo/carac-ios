//
//  caracApp.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftData
import SwiftUI

@main
struct caracApp: App {
    @AppStorage("tintColor") var tintColor = "#007AFF"

    @StateObject var mainViewState = MainViewState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Session.self,
            Exercise.self,
            ExerciseSet.self,
            Training.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: {
            #if DEBUG
            true
            #else
            false
            #endif
        }())

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .tint(Color(hex: tintColor) ?? .blue)
                .environmentObject(mainViewState)
        }
        .modelContainer(sharedModelContainer)
    }
}
