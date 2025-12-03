//
//  GlobalSettingsView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

enum Theme: String, Codable, CaseIterable {
    case systemDefault
    case light
    case dark

    var colorScheme: ColorScheme? {
        switch self {
            case .systemDefault:
                return nil
            case .light:
                return .light
            case .dark:
                return .dark
        }
    }

    var title: String {
        switch self {
            case .systemDefault:
                return "System default"
            case .light:
                return "Light"
            case .dark:
                return "Dark"
        }
    }
}

struct GlobalSettingsView: View {
    @EnvironmentObject var mainViewState: MainViewState

    @AppStorage("tintColor") var tintColor = "#007AFF"
    @AppStorage("preferedTheme") var theme: Theme = .systemDefault

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
                        ForEach(Theme.allCases, id: \.self.rawValue) { theme in
                            Text(theme.title)
                                .tag(theme)
                        }
                    }
                }
                HelpUsSection()
            }
            .navigationTitle("Settings")
            .closeButton()
        }
        .preferredColorScheme(theme.colorScheme)
    }
}

#Preview {
    GlobalSettingsView()
}
