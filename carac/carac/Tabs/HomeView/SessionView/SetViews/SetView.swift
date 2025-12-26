//
//  SetView.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import SwiftData
import SwiftUI

struct SetView: View {
    @State private var isFinished: Bool = false

    @Binding var set: ExerciseSetDraft

    let exerciseWeightStep: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                DynamicStepper(value: $set.weight, step: exerciseWeightStep, text: "Weight: \(set.weight.maxDigits(2))kg", systemImage: "dumbbell.fill", isFinished: isFinished)

                DynamicStepper(value: $set.reps.asDouble, step: 1.0, text: "Reps: \(set.reps)", systemImage: "arrow.triangle.2.circlepath", isFinished: isFinished)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onStepperBackgroundTap(perform: handleTap)
            .padding()
            .cardStyle()

            if isFinished {
                Label("Set is finished checkmark", systemImage: "checkmark.circle")
                    .labelStyle(.iconOnly)
                    .font(.largeTitle)
                    .foregroundStyle(.tint)
                    .padding()
            }
        }
        .sensoryFeedback(.success, trigger: isFinished)
        .onBackgroundTap(perform: handleTap)
    }

    private func handleTap() {
        withAnimation(.bouncy) {
            isFinished.toggle()
        }
    }
}

extension Binding where Value == Int {
    var asDouble: Binding<Double> {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Int($0) }
        )
    }
}

#Preview {
    @Previewable @State var sampleSet = ExerciseSetDraft(id: 0, reps: 10, weight: 75)
    List {
        SetView(set: $sampleSet, exerciseWeightStep: 2.5)
            .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
}
