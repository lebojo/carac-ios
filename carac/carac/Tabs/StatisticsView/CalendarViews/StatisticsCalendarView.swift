//
//  StatisticsCalendarView.swift
//  carac
//
//  Created by Jordan Chap on 24.11.2025.
//

import SwiftData
import SwiftUI

struct StatisticsCalendarView: View {
    @Environment(\.modelContext) var modelContext

    @State private var disabledDates: [Date] = []

    @Binding var selectedDate: Date

    var body: some View {
        CustomCalendarView(selectedDate: $selectedDate, activatedDate: disabledDates)
            .task {
                fetchDisabledDates()
            }
    }

    func fetchDisabledDates() {
        do {
            var descriptor = FetchDescriptor<Session>()
            descriptor.propertiesToFetch = [\.date]

            let sessions = try modelContext.fetch(descriptor)
            disabledDates = sessions.map(\.date)
        } catch {
            print("Oups : \(error)")
        }
    }
}

#Preview {
    List {
        StatisticsCalendarView(selectedDate: .constant(.now))
    }
}
