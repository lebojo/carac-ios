//
//  PreviewHelper.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Foundation

let sampleMainViewState = MainViewState()

// MARK: - Draft

let sampleExerciseDraft = ExerciseDraft(name: "Curl series draft", weightSteps: 2, sets: [ExerciseSetDraft(id: 0)])
let sampleTrainingDraft = TrainingDraft("Sample training draft", exercises: [sampleExerciseDraft])

// MARK: - Model

let sampleExercise = Exercise(name: "Curl series", weightSteps: 2, sets: [ExerciseSet(id: 0)])
let sampleTraining = Training("Sample training", exercises: [sampleExercise])
