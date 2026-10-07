//
//  GlobalSettingsToolbarModifier.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

extension View {
    func globalSettingsToolbar(placement: ToolbarItemPlacement = .automatic) -> some View {
        modifier(GlobalSettingsToolbarModifier(placement: placement))
    }
}

struct GlobalSettingsToolbarModifier: ViewModifier {
    @State private var isSettingsVisible: Bool = false

    let placement: ToolbarItemPlacement

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: placement) {
                    Button("Global settings", systemImage: "gear") {
                        isSettingsVisible = true
                    }
                }
            }
            .sheet(isPresented: $isSettingsVisible) {
                GlobalSettingsView()
                    .presentationDragIndicator(.visible)
            }
    }
}
