import SwiftUI

struct CustomCalendarView: View {
    @State private var displayedMonth: Date

    @Binding var selectedDate: Date

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    private var activatedDates: Set<Date>

    private var monthHeader: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }

    private var weekdaySymbols: [String] {
        calendar.shortWeekdaySymbols
    }

    private var startOffset: Int {
        let components = calendar.dateComponents([.year, .month], from: displayedMonth)
        let firstOfMonth = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        return (weekday - calendar.firstWeekday + 7) % 7
    }

    private var daysInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)) else { return [] }

        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth)
        }
    }

    init(selectedDate: Binding<Date>, activatedDates: [Date]) {
        self._selectedDate = selectedDate
        let calendar = Calendar.current
        self.activatedDates = Set(activatedDates.map { calendar.startOfDay(for: $0) })
        self._displayedMonth = State(initialValue: selectedDate.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 25) {
                Image(systemName: "chevron.left")
                    .contentShape(Rectangle())
                    .onTapGesture { changeMonth(by: -1) }
                    .accessibilityLabel("Previous month")

                Text(monthHeader.capitalized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)

                Image(systemName: "chevron.right")
                    .contentShape(Rectangle())
                    .onTapGesture { changeMonth(by: 1) }
                    .accessibilityLabel("Next month")
            }
            .font(.body)
            .foregroundColor(.accentColor)
            .animation(.bouncy, value: displayedMonth)

            HStack {
                ForEach(weekdaySymbols, id: \.self) { day in
                    Text(day.uppercased())
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)

            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0 ..< startOffset, id: \.self) { _ in Spacer() }

                ForEach(daysInMonth, id: \.self) { date in
                    let isActive = isDateActive(date)
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                    let isToday = calendar.isDateInToday(date)

                    Text("\(calendar.component(.day, from: date))")
                        .font(.title3)
                        .fontWeight((isSelected || isToday) ? .semibold : .regular)
                        .frame(width: 40, height: 40)
                        .background(isSelected ? .accentColor.opacity(0.1) : Color.clear)
                        .foregroundColor(
                            isSelected || isToday ? .accentColor :
                                (isActive ? .primary : .gray.opacity(0.3))
                        )
                        .clipShape(Circle())
                        .accessibilityLabel(accessibilityLabel(for: date, isActive: isActive, isSelected: isSelected, isToday: isToday))
                        .accessibilityHint(isActive ? "Double tap to select this date" : "")
                        .onTapGesture {
                            guard isActive else { return }
                            selectedDate = date
                        }
                }
            }
        }
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .animation(.easeOut(duration: 0.25), value: selectedDate)
    }

    private func isDateActive(_ date: Date) -> Bool {
        activatedDates.contains(calendar.startOfDay(for: date))
    }

    private func accessibilityLabel(for date: Date, isActive: Bool, isSelected: Bool, isToday: Bool) -> String {
        let dayNumber = calendar.component(.day, from: date)
        var label = "Day \(dayNumber)"
        
        if isToday {
            label += ", today"
        }
        
        if isActive {
            label += ", has sessions"
        } else {
            label += ", no sessions available"
        }
        
        if isSelected {
            label += ", selected"
        }
        
        return label
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
}
