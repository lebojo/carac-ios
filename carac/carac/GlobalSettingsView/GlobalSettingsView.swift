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

    var body: some View {
        NavigationStack {
            List {
                Section("Customization") {
                    SimpleColorPicker(selection: Binding(get: {
                        Color(hex: tintColor) ?? .blue
                    }, set: {
                        tintColor = $0.hex
                    }))
                }
                HelpUsSection()
            }
            .navigationTitle("Settings")
            .closeButton()
        }
    }
}

#Preview {
    GlobalSettingsView()
}
