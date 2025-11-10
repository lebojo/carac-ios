//
//  WeekHomeView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct WeekHomeView: View {
    let trainings: [Training]

    var body: some View {
        ForEach(RepeatDay.allCases.filter { $0 != .noRepeat }, id: \.self) { day in
            HStack {
                Text(day.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(trainings.filter { $0.repeatDays.contains(day.rawValue) }.map(\.title).joined(separator: ", "))
                    .lineLimit(1)
                    .italic()
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    WeekHomeView(trainings: [sampleTraining, sampleTraining])
}
