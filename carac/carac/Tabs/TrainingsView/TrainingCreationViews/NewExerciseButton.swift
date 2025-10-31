//
//  NewExerciseButton.swift
//  carac
//
//  Created by Jordan Chap on 18.10.2025.
//

import SwiftUI

struct NewExerciseButton: View {
    @EnvironmentObject var mainViewState: MainViewState
    
    @State private var showCreateExercise: Bool = false
    
    var body: some View {
        Button("New", systemImage: "plus") {
            showCreateExercise.toggle()
        }
        .lineLimit(1)
        .padding()
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16.0))
        .shadow(radius: 5.0)
        .sheet(isPresented: $showCreateExercise) {
            CreateAnExerciseSheetView(isPresented: $showCreateExercise)
        }
    }
}

#Preview {
    NewExerciseButton()
}
