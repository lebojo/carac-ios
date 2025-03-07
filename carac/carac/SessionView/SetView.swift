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

    var body: some View {
        Section("Set \(set.id)") {
            Stepper("Weight: \(set.weight.formatted())kg", value: Binding(get: {
                set.weight
            }, set: { value in
                set.weight = value
            }), step: 0.5)

            Stepper("Reps: \(set.reps)", value: Binding(get: {
                set.reps
            }, set: { value in
                set.reps = value
            }))
        }
    }
}
