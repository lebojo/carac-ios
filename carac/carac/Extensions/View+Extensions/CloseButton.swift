//
//  CloseFullScreen.swift
//  carac
//
//  Created by Jordan on 13.04.2025.
//

import SwiftUI

extension View {
    public func closeButton() -> some View {
        modifier(CloseButton())
    }
}

struct CloseButton: ViewModifier {
    @EnvironmentObject var mainViewState: MainViewState

    func body(content: Content) -> some View {
        content
            .toolbar {
                Button("Close", systemImage: "xmark") {
                    mainViewState.backHome()
                }
            }
    }
}
