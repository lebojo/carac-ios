//
//  View+GlassMorphStyle.swift
//  carac
//
//  Created by Jordan on 24.05.902025.
//

import SwiftUI

extension View {
    func glassEffectStyle(_ glassEffect: GlassEffect.GlassType = .regular, cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassEffect(glassEffect: glassEffect, cornerRadius: cornerRadius))
    }

    func glassButton() -> some View {
        modifier(GlassEffectButton())
    }
}

struct GlassEffect: ViewModifier {
    let glassEffect: GlassType
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(glassEffect.nativeGlass)
        } else {
            content
                .background(.thinMaterial)
                .cornerRadius(cornerRadius)
                .shadow(color: .cardShadow, radius: 3, y: 3)
        }
    }

    enum GlassType {
        case clear
        case regular

        @available(iOS 26.0, *)
        var nativeGlass: Glass {
            switch self {
            case .clear:
                .clear
            case .regular:
                .regular
            }
        }
    }
}


struct GlassEffectButton: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .buttonStyle(.glassProminent)
        } else {
            content
                .buttonStyle(.borderedProminent)
        }
    }
}
