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
    @StateObject var mainViewState = MainViewState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Session.self,
            Exercise.self,
            ExerciseSet.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(mainViewState)
        }
        .modelContainer(sharedModelContainer)
    }
}
