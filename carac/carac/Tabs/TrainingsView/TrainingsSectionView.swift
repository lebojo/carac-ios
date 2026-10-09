//
//  TrainingsSectionView.swift
//  carac
//
//  Created by Jordan on 07.10.2026.
//

import SwiftData
import SwiftUI

struct TrainingsSectionView: View {
    @Environment(\.modelContext) private var modelContext

    let trainings: [Training]
    let onCreate: () -> Void

    var body: some View {
        if !trainings.isEmpty {
            Section("Trainings") {
                ForEach(trainings, id: \.persistentModelID) { training in
                    NavigationLink(training.title, value: training)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(trainings[index])
                    }
                }
            }
        } else {
            ContentUnavailableView {
                Label("No trainings yet", systemImage: "figure.strengthtraining.traditional")
            } description: {
                Text("Create your first training to start your sessions.")
            } actions: {
                Button("Create a new training", systemImage: "plus", action: onCreate)
                    .glassButton()
            }
        }
    }
}
