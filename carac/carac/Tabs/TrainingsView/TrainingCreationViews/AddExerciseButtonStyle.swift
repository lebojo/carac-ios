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
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.white)
            .background(isActive ? .green : .accentColor.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .contentShape(RoundedRectangle(cornerRadius: 16))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .lineLimit(2, reservesSpace: true)
    }
}


extension ButtonStyle where Self == ExerciseButtonStyle {
    static func exerciseButton(_ isActive: Bool = false) -> ExerciseButtonStyle {
        ExerciseButtonStyle(isActive: isActive)
    }
}
