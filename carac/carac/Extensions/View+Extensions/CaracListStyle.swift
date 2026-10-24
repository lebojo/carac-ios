//
//  CaracListStyle.swift
//  carac
//
//  Created by Jordan Chap on 24.04.2026.
//

import SwiftUI

struct CaracListStyleModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(colorScheme == .dark ? nil : Color.accentColor.opacity(0.05).ignoresSafeArea())
    }
}

extension View {
    func caracBackground() -> some View {
        modifier(CaracListStyleModifier())
    }
}

extension List {
    func caracListStyle() -> some View {
        scrollContentBackground(.hidden)
            .modifier(CaracListStyleModifier())
    }
}
