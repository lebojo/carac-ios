//
//  ChartPreviewLineMark.swift
//  carac
//
//  Created by Jordan Chap on 23.12.2025.
//


import Charts
import SwiftUI

struct ChartPreviewLineMark: ChartContent {
    let last: (totalWeight: Double, date: Date)
    let current: (totalWeight: Double, date: Date)

    var body: some ChartContent {
        ForEach([last, current], id: \.date) { item in
            LineMark(
                x: .value("date", item.date),
                y: .value("Weight", item.totalWeight),
                series: .value("type", "current")
            )
            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
            .foregroundStyle(current.totalWeight > last.totalWeight ? .green : .red)
        }

        PointMark(
            x: .value("date", current.date),
            y: .value("Weight", current.totalWeight)
        )
        .foregroundStyle(current.totalWeight > last.totalWeight ? .green : .red)
    }
}
