//
//  BackgroundTapFix.swift
//  carac
//
//  Created by Jordan Chap on 29.11.2025.
//

import SwiftData
import SwiftUI

struct BackgroundTapFix: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .onTapGesture(perform: action)
        } else {
            content
        }
    }
}

struct BackgroundStepperTapFix: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
        } else {
            content
                .background(
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture(perform: action)
                )
        }
    }
}

extension View {
    func onBackgroundTap(perform action: @escaping () -> Void) -> some View {
        modifier(BackgroundTapFix(action: action))
    }

    func onStepperBackgroundTap(perform action: @escaping () -> Void) -> some View {
        modifier(BackgroundStepperTapFix(action: action))
    }
}
