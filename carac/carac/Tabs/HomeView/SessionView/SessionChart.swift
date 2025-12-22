//
//  SessionChart.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Charts
import SwiftUI

struct SessionChart: View {
    let data: [(totalWeight: Double, date: Date)]

    var body: some View {
        Chart {
            ForEach(data, id: \.date) { i in
                LineMark(
                    x: .value("date", i.date),
                    y: .value("Weight", i.totalWeight)
                )
                .foregroundStyle(.tint)

                PointMark( // Ajoute ça
                    x: .value("date", i.date),
                    y: .value("Weight", i.totalWeight)
                )
                .foregroundStyle(.tint)
            }
        }
        .chartYScale(domain: 0 ... (data.map { $0.totalWeight }.max() ?? 0) + 1)
        .chartLegend(.visible)
    }
}

#Preview {
    VStack {
        Text("Title")
        SessionChart(data: [
            (totalWeight: 1.0, date: .now.addingTimeInterval(-100)),
            (totalWeight: 1.5, date: .now),
            (totalWeight: 1.7, date: .now.addingTimeInterval(100)),
        ])
        .padding()
    }
}
