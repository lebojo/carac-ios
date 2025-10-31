//
//  SetView.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import SwiftData
import SwiftUI

struct SetView: View {
    @Bindable var set: ExerciseSet
    
    let exerciseWeightStep: Double

    var body: some View {
        VStack(spacing: 20) {
            Stepper(value: Binding(get: {
                set.weight
            }, set: { value in
                set.weight = value
            }), in: 0 ... 200, step: exerciseWeightStep) {
                Label("Weight: \(set.weight.formatted())kg", systemImage: "dumbbell.fill")
            }

            Stepper(value: Binding(get: {
                set.reps
            }, set: { value in
                set.reps = value
            }), in: 0 ... 200) {
                Label("Reps: \(set.reps)", systemImage: "arrow.triangle.2.circlepath")
            }
        }
        .cardStyle()
    }
}

#Preview {
    SetView(set: ExerciseSet(id: 1), exerciseWeightStep: 0.5)
}
