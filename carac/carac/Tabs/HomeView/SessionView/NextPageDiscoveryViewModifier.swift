//
//  NextPageDiscoveryViewModifier.swift
//  carac
//
//  Created by Jordan Chap on 10.01.2026.
//

import SwiftUI

struct NextPageDiscoveryViewModifier: ViewModifier {
    @State private var hasScrolled: Bool = false

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .safeAreaPadding(.trailing, hasScrolled ? 0 : 30)
                .onScrollPhaseChange { _, newPhase in
                    if newPhase == .interacting { hasScrolled = true }
                }
        } else {
            content
                .safeAreaPadding(.trailing, hasScrolled ? 0 : 30)
                .simultaneousGesture(
                    DragGesture().onChanged { _ in
                        if !hasScrolled { hasScrolled = true }
                    }
                )
        }
    }
}
