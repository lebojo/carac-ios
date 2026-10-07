//
//  GlobalSettingsView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct GlobalSettingsView: View {
    @EnvironmentObject var mainViewState: MainViewState

    @AppStorage("tintColor") var tintColor = "#007AFF"
    @AppStorage("preferedTheme") var theme: DeviceTheme = .systemDefault
    @AppStorage(WorkoutManager.isEnabledKey) var isWorkoutEnabled = WorkoutManager.isEnabledDefault

    var body: some View {
        NavigationStack {
            List {
                Section("Customization") {
                    SimpleColorPicker(selection: Binding(get: {
                        Color(hex: tintColor) ?? .blue
                    }, set: {
                        tintColor = $0.hex
                    }))

                    Picker("Color scheme", selection: $theme) {
                        ForEach(DeviceTheme.allCases, id: \.self.rawValue) { theme in
                            Text(theme.title)
                                .tag(theme)
                        }
                    }
                }

                Section {
                    Toggle("Record workouts in Apple Fitness", isOn: $isWorkoutEnabled)
                } header: {
                    Text("Apple Health")
                } footer: {
                    Text("Starts a strength training workout when a session begins and saves it when the session is saved.")
                }

                HelpUsSection()

                Section("Your data") {
                    ExportDataToJsonButtonView()
                    ImportDataFromJsonButtonView()
                }
            }
            .caracListStyle()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .closeButton()
        }
        .preferredColorScheme(theme.colorScheme)
    }
}

#Preview {
    GlobalSettingsView()
}
