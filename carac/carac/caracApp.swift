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
    @AppStorage("preferedTheme") var theme: DeviceTheme = .systemDefault

    @StateObject var mainViewState = MainViewState()

    var sharedModelContainer: ModelContainer = {
        let modelConfiguration = ModelConfiguration(
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
                for: Session.self,
                migrationPlan: CaracSchemaMigrationPlan.self,
                configurations: [modelConfiguration]
            )

            #if DEBUG
                if UserDefaults.standard.bool(forKey: "enableDebugSeeding") {
                    let context = container.mainContext
                    let faker = Faker(modelContext: context)

                    faker.fakeAppActivity()
                }
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
