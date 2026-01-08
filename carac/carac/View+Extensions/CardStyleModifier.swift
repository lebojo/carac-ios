//
//  CardStyle.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import Foundation
import SwiftUI

extension View {
    public func cardStyle() -> some View {
        modifier(CardStyleModifier())
    }
}

struct CardStyleModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16.0)
                    .fill(Color("cardBackground"))
                    .shadow(color: Color("cardShadow").opacity(0.3), radius: 8, x: 0, y: 4)
                    .shadow(color: Color("cardShadow").opacity(0.15), radius: 2, x: 0, y: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 16.0))
    }
}
