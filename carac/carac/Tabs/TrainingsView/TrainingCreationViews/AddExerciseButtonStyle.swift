//
//  AddExerciseButtonStyle.swift
//  carac
//
//  Created by Jordan Chap on 18.10.2025.
//

import SwiftUI

struct ExerciseButtonStyle: ButtonStyle {
    let isActive: Bool
    
    init(isActive: Bool = false) {
        self.isActive = isActive
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isActive ? .green : .accentColor.opacity(0.2))
                    .shadow(color: isActive ? .green.opacity(0.3) : .accentColor.opacity(0.1), radius: configuration.isPressed ? 2 : 8, y: configuration.isPressed ? 1 : 4)
            )
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 16))
            .opacity(configuration.isPressed ? 0.9 : 1)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .lineLimit(2, reservesSpace: true)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}


extension ButtonStyle where Self == ExerciseButtonStyle {
    static func exerciseButton(_ isActive: Bool = false) -> ExerciseButtonStyle {
        ExerciseButtonStyle(isActive: isActive)
    }
}
