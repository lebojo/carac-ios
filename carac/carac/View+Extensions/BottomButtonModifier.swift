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
                Button(title, systemImage: systemName) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        action()
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .disabled(disabled)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 0)
                )
            }
    }
}
