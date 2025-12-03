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
    @AppStorage("preferedTheme") var theme: Theme = .systemDefault

    @StateObject var mainViewState = MainViewState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema(
            [
                Session.self,
                Exercise.self,
                ExerciseSet.self,
                Training.self
            ]
        )
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: {
                #if DEBUG
                    true
                #else
                    false
                #endif
            }()
        )

        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            #if DEBUG
                let context = container.mainContext
                let faker = Faker(modelContext: context)

                faker.fakeAppActivity()
            #endif

            return container
        } catch {
            fatalError(
                "Could not create ModelContainer: \(error)"
            )
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(theme.colorScheme)
                .tint(
                    Color(
                        hex: tintColor
                    ) ?? .blue
                )
                .environmentObject(
                    mainViewState
                )
        }
        .modelContainer(
            sharedModelContainer
        )
    }
}
