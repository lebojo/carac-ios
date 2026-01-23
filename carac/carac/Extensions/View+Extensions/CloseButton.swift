//
//  CloseFullScreen.swift
//  carac
//
//  Created by Jordan on 13.04.2025.
//

import SwiftUI

public extension View {
    func closeButton() -> some View {
        modifier(CloseButton())
    }
}

struct CloseButton: ViewModifier {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var mainViewState: MainViewState

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    if #available(iOS 26.0, *) {
                        Button(role: .close) {
                            dismiss()
                        }
                    } else {
                        Button("Close", systemImage: "xmark") {
                            dismiss()
                        }
                    }
                }
            }
    }
}
