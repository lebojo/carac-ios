//
//  RepeatDayPicker.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct RepeatDayPicker: View {
    @Bindable var newTraining: Training

    var newExerciseSystemName: String {
        guard #available(iOS 18, *) else {
            return "checkmark"
        }
        return "checkmark.arrow.trianglehead.counterclockwise"
    }

    var body: some View {
        List {
            ForEach(RepeatDay.allCases.filter { $0 != .noRepeat }, id: \.self) { day in
                Button {
                    toggleDay(day)
                } label: {
                    HStack {
                        Text("Every \(day.title)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.foreground)
                        if newTraining.repeatDays.contains(day.rawValue) {
                            Image(systemName: newExerciseSystemName)
                                .tint(.accentColor)
                        }
                    }
                }
            }
        }
        .navigationTitle("Repeat days")
    }

    func toggleDay(_ day: RepeatDay) {
        withAnimation{
            if let index = newTraining.repeatDays.firstIndex(of: day.rawValue) {
                newTraining.repeatDays.remove(at: index)
            } else {
                newTraining.repeatDays.append(day.rawValue)
            }
        }
    }
}

#Preview {
    List {
        RepeatDayPicker(newTraining: sampleTraining)
    }
}
