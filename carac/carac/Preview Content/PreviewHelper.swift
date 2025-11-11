//
//  PreviewHelper.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Foundation
import SwiftData

let sampleMainViewState = MainViewState()

// MARK: - Draft

let sampleExerciseDraft = ExerciseDraft(name: "Curl series draft", weightSteps: 2, sets: [ExerciseSetDraft(id: 0)])
let sampleTrainingDraft = TrainingDraft("Sample training draft", exercises: [sampleExerciseDraft])

// MARK: - Model

let sampleExercise = Exercise(name: "Curl series", weightSteps: 2, sets: [ExerciseSet(id: 0)])
let sampleTraining = Training("Sample training", exercises: [sampleExercise])

class Faker {
    let modelContext: ModelContext

    let templatesTrainings: [Training]
    let templatesExercises: [Exercise]

    init(modelContext: ModelContext) {
        self.modelContext = modelContext

        let tmpTemplatesExercises = ["Curl series", "Deadlift", "Push up", "Dumbbell flyes"].map { name in
            let emptyExercise = Exercise(name: name, weightSteps: Double.random(in: 0.1...10.0))
            modelContext.insert(emptyExercise)
            return emptyExercise
        }

        templatesTrainings = [
            (RepeatDay.monday,    "Upper Body"),
            (RepeatDay.tuesday,   "Lower Body"),
            (RepeatDay.wednesday, "Full Body"),
            (RepeatDay.thursday,  "Push Day"),
            (RepeatDay.friday,    "Pull Day"),
            (RepeatDay.saturday,  "Core & Mobility"),
            (RepeatDay.sunday,    "Active Recovery")
        ].map { title in
            let exercisesCount = Int.random(in: 1...tmpTemplatesExercises.count)
            let emptyTraining = Training(title.1, exercises: [], repeatDays: [title.0])

            modelContext.insert(emptyTraining) // Training and exercises in same context

            emptyTraining.exercises = tmpTemplatesExercises.shuffled().prefix(exercisesCount).map(\.self)

            return emptyTraining
        }

        templatesExercises = tmpTemplatesExercises
    }

    /// Create a fake activity in the modelContext
    /// With random sessions on randoms days
    func fakeAppActivity() {
        let 📅 = Calendar.current
        let today = 📅.startOfDay(for: Date())

        let twoWeeksDates = (-14...0).map { dayOffset in
            📅.date(byAdding: .day, value: dayOffset, to: today)!
        }

        for date in twoWeeksDates {
            let repeatDay = RepeatDay.from(date: date)
            let trainings = templatesTrainings.filter { $0.repeatDays.contains(repeatDay.rawValue) }

            let fakeTrainings = trainings.map { training in
                Training(training.title, exercises: training.exercises.map { exercise in
                    Exercise(name: exercise.name, weightSteps: exercise.weightSteps, sets: [
                        ExerciseSet(id: 0, reps: 12, weight: exercise.weightSteps),
                        ExerciseSet(id: 1, reps: 12, weight: exercise.weightSteps * 2),
                        ExerciseSet(id: 2, reps: 10, weight: exercise.weightSteps * 3)
                    ])
                })
            }

            for training in fakeTrainings {
                let session = Session(date: date, training: training)

                modelContext.insert(session)
            }
        }
    }
}
