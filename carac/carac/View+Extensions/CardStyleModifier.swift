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
    func body(content: Content) -> some View {
        content
            .padding()
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
            .shadow(color: Color("cardShadow"), radius: 3, x: 0, y: 3)
    }
}
