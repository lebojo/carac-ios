//
//  SettingsToolbarView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct SettingsToolbarView: View {
    @EnvironmentObject var mainViewState: MainViewState

    @State private var isSettingsVisible: Bool = false

    var body: some View {
        Button {
            isSettingsVisible = true
        } label: {
            Label("Global settings", systemImage: "gear")
        }
        .sheet(isPresented: $isSettingsVisible) {
            GlobalSettingsView()
                .presentationDragIndicator(.visible)
        }
    }
}
