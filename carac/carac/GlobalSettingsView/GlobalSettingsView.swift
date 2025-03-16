//
//  GlobalSettingsView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct GlobalSettingsView: View {
    @AppStorage("tintColor") var tintColor = "#007AFF"

    var body: some View {
        List {
            Section("Customization") {
                SimpleColorPicker(selection: Binding(get: {
                    Color(hex: tintColor) ?? .blue
                }, set: {
                    tintColor = $0.hex
                }))
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    GlobalSettingsView()
}
