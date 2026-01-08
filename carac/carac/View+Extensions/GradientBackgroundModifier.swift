//
//  GradientBackgroundModifier.swift
//  carac
//
//  Created by Copilot on 08.01.2026.
//

import SwiftUI

extension View {
    func subtleGradientBackground() -> some View {
        modifier(SubtleGradientBackgroundModifier())
    }
}

struct SubtleGradientBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: colorScheme == .dark ? 
                        [Color.black, Color("cardBackground").opacity(0.3)] :
                        [Color.white, Color.gray.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
    }
}
