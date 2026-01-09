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

    @State private var activeDates: [Date] = []

    @Binding var selectedDate: Date

    var body: some View {
        CustomCalendarView(selectedDate: $selectedDate, activatedDates: activeDates)
            .task {
                fetchActiveDates()
            }
    }

    func fetchActiveDates() {
        do {
            var descriptor = FetchDescriptor<Session>()
            descriptor.propertiesToFetch = [\.date]

            let sessions = try modelContext.fetch(descriptor)
            activeDates = sessions.map(\.date)
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
