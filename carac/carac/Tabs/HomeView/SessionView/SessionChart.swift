//
//  SessionChart.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import SwiftUI
import Charts

struct SessionChart: View {
    let weights: [Double]
    let reps: [Int]

    var body: some View {
        Chart {
            ForEach(weights.indices, id: \.self) { index in
                LineMark(
                    x: .value("Set", index),
                    y: .value("Weight", weights[index])
                )
                .foregroundStyle(.secondary)
            }

            ForEach(reps.indices, id: \.self) { index in
                BarMark(
                    x: .value("Set", index),
                    y: .value("Reps", reps[index])
                )

            }
        }
        .chartXScale(domain: 0 ... weights.count)
        .chartYScale(domain: 0 ... max(Int(weights.max() ?? 0), reps.max() ?? 0) + 1)
        .chartLegend(.visible)
    }
}

#Preview {
    SessionChart(weights: [1, 1.5, 3, 3.5, 10], reps: [1, 4, 5, 3, 6])
        .padding()
}
