//
//  RepeatDayPicker.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct RepeatDayPicker: View {
    @Bindable var newExercise: Exercise

    var newExerciseSystemName: String {
        guard #available(iOS 18, *) else {
            return "checkmark"
        }
        return "checkmark.arrow.trianglehead.counterclockwise"
    }

    var body: some View {
        ForEach(RepeatDay.allCases.filter { $0 != .noRepeat }, id: \.self) { day in
            Button {
                toggleDay(day)
            } label: {
                HStack {
                    Text("Every \(day.title)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.foreground)
                    if newExercise.days.contains(day.rawValue) {
                        Image(systemName: newExerciseSystemName)
                            .tint(.accentColor)
                    }
                }
            }
        }
    }

    func toggleDay(_ day: RepeatDay) {
        withAnimation{
            if let index = newExercise.days.firstIndex(of: day.rawValue) {
                newExercise.days.remove(at: index)
            } else {
                newExercise.days.append(day.rawValue)
            }
        }
    }
}

#Preview {
    List {
        RepeatDayPicker(newExercise: Exercise())
    }
}
