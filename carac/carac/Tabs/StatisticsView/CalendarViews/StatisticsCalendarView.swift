//
//  StatisticsCalendarView.swift
//  carac
//
//  Created by Jordan Chap on 24.11.2025.
//

import SwiftUI

struct StatisticsCalendarView: View {
    @EnvironmentObject private var statisticsViewState: StatisticsViewState

    @Binding var selectedDate: Date

    var body: some View {
        DatePicker("Wich", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
    }
}

#Preview {
    List {
        StatisticsCalendarView(selectedDate: .constant(.now))
    }
}
