//
//  StatisticsCalendarView.swift
//  carac
//
//  Created by Jordan Chap on 24.11.2025.
//

import SwiftUI

struct StatisticsCalendarView: View {
    @Binding var selectedDate: Date

    var body: some View {
        DatePicker("Statistics date selection", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
    }
}

#Preview {
    List {
        StatisticsCalendarView(selectedDate: .constant(.now))
    }
}
