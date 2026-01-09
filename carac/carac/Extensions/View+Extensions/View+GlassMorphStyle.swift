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
}

struct GlassEffect: ViewModifier {
    let glassEffect: GlassType
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(glassEffect.nativeGlass, in: .rect(cornerRadius: cornerRadius))
        } else {
            content
                .background(.thinMaterial)
                .cornerRadius(cornerRadius)
                .shadow(radius: 3)
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
