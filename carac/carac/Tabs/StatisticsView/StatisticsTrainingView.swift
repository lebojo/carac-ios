//
//  StatisticsTrainingView.swift
//  carac
//
//  Created by Jordan Chap on 02.12.2025.
//

import SwiftData
import SwiftUI

struct StatisticsTrainingView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var dataSessions: [Session]

    @State private var isShowingConfirmation: Bool = false
    @State private var sessionToDelete: Session? = nil

    let trainingTitle: String

    let currentSession: SessionDraft?

    private var sessions: [Session] {
        dataSessions.filter { $0.training.title == trainingTitle }
    }

    private var sessionsCount: Int {
        let sessionsCount = sessions.count
        if let currentSession, currentSession.totalWeightPulled > 0 {
            return sessionsCount + 1
        }
        return sessionsCount
    }

    private var totalWeightPulled: Double {
        let totalSessionWeightPulled = sessions.reduce(0) { $0 + $1.totalWeightPulled }
        if let currentSession, currentSession.totalWeightPulled > 0 {
            return currentSession.totalWeightPulled + totalSessionWeightPulled
        }
        return totalSessionWeightPulled
    }

    private var bestSession: (weightPulled: Double, date: Date)? {
        guard let best = sessions
            .filter({ $0.totalWeightPulled > 0 })
            .max(by: { lhs, rhs in lhs.totalWeightPulled < rhs.totalWeightPulled })
        else {
            return nil
        }

        return (best.totalWeightPulled, best.date)
    }

    var averageTrend: String? {
        let sorted = sessions.sorted { $0.date < $1.date }
        guard sorted.count > 1 else { return nil }

        // Crée des paires (Session N, Session N+1)
        var changes = zip(sorted, sorted.dropFirst()).compactMap { prev, curr -> Double? in
            guard prev.totalWeightPulled > 0 else { return nil }

            return (curr.totalWeightPulled - prev.totalWeightPulled) / prev.totalWeightPulled
        }

        guard !changes.isEmpty else { return nil }

        if let currentSession, let last = sorted.last {
            changes.append((currentSession.totalWeightPulled - last.totalWeightPulled) / last.totalWeightPulled)
        }

        let average = changes.reduce(0, +) / Double(changes.count)

        return average.formatted(.percent.sign(strategy: .always()).precision(.fractionLength(1)))
    }

    var body: some View {
        List {
            if sessions.count > 1 {
                SessionChart(data: sessions.map {
                    ($0.totalWeightPulled, $0.date)
                }, currentSessionData: currentSession.map { ($0.totalWeightPulled, $0.date) })
                    .padding()
            }

            Section(currentSession != nil ? "Global training stats with today" : "Global training stats") {
                HallOfGloryView(totalWeightPulled: totalWeightPulled)
                Text("Total times done: **\(sessions.count)**")
                if let bestSession {
                    Text("Best: **\(bestSession.weightPulled)** at **\(bestSession.date.formatted(date: .abbreviated, time: .omitted))**")
                }
                Text("Average: **\(sessionsCount > 0 ? totalWeightPulled / Double(sessionsCount) : 0)**")
                if let averageTrend {
                    Text("Average trend: \(coloredAverageTrend(averageTrend))")
                }
            }

            Section("Every training session") {
                ForEach(sessions) { session in
                    Text("\(session.date.formatted())")
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let trainingToDelete = sessions[index]
                        sessionToDelete = trainingToDelete
                        isShowingConfirmation = true
                    }
                }

                if let currentSession {
                    Text("\(currentSession.date.formatted()) (Today)")
                        .italic()
                }
            }
            .alert("Do you confirm ?", isPresented: $isShowingConfirmation, presenting: sessionToDelete) { item in
                Button("Cancel", role: .cancel) { isShowingConfirmation = false }
                Button("Delete", role: .destructive) {
                    modelContext.delete(item)
                }
            } message: { _ in
                Text("This action cannot be undone")
            }
        }
        .navigationTitle("\(trainingTitle)")
    }

    private func coloredAverageTrend(_ trend: String) -> Text {
        switch trend.first {
            case "+":
                return Text(trend).foregroundStyle(.green).bold()
            case "-":
                return Text(trend).foregroundStyle(.red).bold()
            default:
                return Text(trend).bold()
        }
    }
}

#Preview {
    StatisticsTrainingView(trainingTitle: sampleTraining.title, currentSession: nil)
}
