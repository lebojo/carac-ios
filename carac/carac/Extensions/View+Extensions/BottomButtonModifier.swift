//
//  BottomButtonModifier.swift
//  carac
//
//  Created by Jordan on 16.03.2025.
//

import SwiftData
import SwiftUI

extension View {
    func bottomButton(title: String, systemName: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        modifier(BottomButtonModifier(title: title, systemName: systemName, disabled: disabled, action: action))
    }
}

struct BottomButtonModifier: ViewModifier {
    @EnvironmentObject var mainViewState: MainViewState
    @Environment(\.modelContext) private var modelContext

    let title: String
    let systemName: String
    let disabled: Bool
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button(title, systemImage: systemName) {
                        action()
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    .disabled(disabled)
                    .glassEffectStyle()
                }
                .frame(maxWidth: .infinity)
                .background(.background)
            }
    }
}
