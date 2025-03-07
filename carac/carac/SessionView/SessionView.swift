//
//  SessionView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftData
import SwiftUI

struct SessionView: View {
    @Environment(\.modelContext) private var modelContext

    let exercises: [Exercise]

    var body: some View {
        TabView {
            ForEach(exercises) { exercise in
                ExerciseListView(exercise: exercise)
            }
        }
        .tabViewStyle(.page)
        .safeAreaInset(edge: .bottom) {
            Button {
                try! modelContext.save()
                print("Save")
            } label: {
                Label("Save now", systemImage: "opticaldisc")
            }
        }
    }
}

#Preview {
    NavigationStack {
        SessionView(exercises: [Exercise(name: "Abdos au sol", days: [RepeatDay.today]),
                                Exercise(name: "Curl des biceps", days: [RepeatDay.today])])
        .navigationTitle("Dimanche")
    }
}
