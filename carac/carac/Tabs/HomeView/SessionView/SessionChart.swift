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
    var currentSessionData: (totalWeight: Double, date: Date)? = nil

    private var maxWeight: Double {
        let dataMaxWeight = data.map(\.totalWeight).max() ?? 0
        if let currentSessionData {
            return max(dataMaxWeight, currentSessionData.totalWeight)
        }
        return dataMaxWeight
    }

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

            if let current = currentSessionData, let last = data.max(by: { $0.date < $1.date }) {
                ChartPreviewLineMark(last: last, current: current)
            }
        }
        .chartYScale(domain: 0 ... maxWeight + 1)
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
        ],
        currentSessionData: (totalWeight: 1.8, date: .now.addingTimeInterval(200)))
            .padding()
    }
}
