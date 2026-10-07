//
//  TrainingsView.swift
//  carac
//
//  Created by Jordan on 14.03.2025.
//

import SwiftData
import SwiftUI

struct TrainingsView: View {
    @State private var activeSheet: Segment?
    @State private var selectedSegment: Segment = .trainings

    @Query(filter: Training.templatePredicate) private var singleTrainings: [Training]
    @Query(filter: Training.donePredicate) private var doneTrainings: [Training]
    @Query(filter: Exercise.withoutSetsPredicate) private var exercisesWithoutSets: [Exercise]

    private var singleExercises: [Exercise] {
        exercisesWithoutSets.excludingSessionCopies(from: doneTrainings)
    }

    var body: some View {
        NavigationStack {
            List {
                switch selectedSegment {
                case .trainings:
                    TrainingsSectionView(
                        trainings: singleTrainings,
                        onCreate: { activeSheet = .trainings }
                    )
                case .exercises:
                    ExercisesSectionView(
                        exercises: singleExercises,
                        onCreate: { activeSheet = .exercises }
                    )
                }
            }
            .caracListStyle()
            .globalSettingsToolbar(placement: .topBarLeading)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Display", selection: $selectedSegment.animation()) {
                        ForEach(Segment.allCases) { segment in
                            Text(segment.title).tag(segment)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") {
                        activeSheet = selectedSegment
                    }
                }
            }
            .navigationTitle(selectedSegment.navigationTitle)
            .navigationDestination(for: Training.self) { training in
                TrainingModificationView(training: training)
            }
            .sheet(item: $activeSheet) { segment in
                switch segment {
                case .trainings:
                    TrainingCreationView()
                case .exercises:
                    CreateAnExerciseSheetView()
                }
            }
        }
    }

    enum Segment: CaseIterable, Identifiable, Sendable {
        case trainings
        case exercises

        var id: Self { self }

        var title: LocalizedStringKey {
            switch self {
                case .trainings: "Trainings"
                case .exercises: "Exercises"
            }
        }

        var navigationTitle: LocalizedStringKey {
            switch self {
                case .trainings: "Carac Trainings"
                case .exercises: "Carac Exercises"
            }
        }
    }
}
