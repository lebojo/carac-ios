import Foundation
import SwiftData

public struct ExerciseSetDraft: Identifiable, Hashable {
    public var id: Int
    public var reps: Int
    public var weight: Double

    public init(id: Int, reps: Int = 10, weight: Double = 1.0) {
        self.id = id
        self.reps = reps
        self.weight = weight
    }

    init(from model: ExerciseSet) {
        self.id = model.id
        self.reps = model.reps
        self.weight = model.weight
    }
}

public struct ExerciseDraft: Identifiable, Hashable {
    public var id: UUID
    public var name: String
    public var weightSteps: Double
    public var sets: [ExerciseSetDraft]

    public init(id: UUID = UUID(), name: String, weightSteps: Double = 1.0, sets: [ExerciseSetDraft] = []) {
        self.id = id
        self.name = name
        self.weightSteps = weightSteps
        self.sets = sets
    }

    init(from model: Exercise) {
        self.id = UUID()
        self.name = model.name
        self.weightSteps = model.weightSteps
        self.sets = model.sets.map { ExerciseSetDraft(from: $0) }
    }
}

public struct TrainingDraft: Identifiable, Hashable {
    public var id: UUID
    public var title: String
    public var exercises: [ExerciseDraft]
    public var repeatDays: [String]

    public init(id: UUID = UUID(), _ title: String, exercises: [ExerciseDraft] = [], repeatDays: [String] = []) {
        self.id = id
        self.title = title
        self.exercises = exercises
        self.repeatDays = repeatDays
    }

    init(from training: Training) {
        self.id = UUID()
        self.title = training.title
        self.repeatDays = training.repeatDays
        self.exercises = training.exercises.map { ex in
            ExerciseDraft(from: ex)
        }
    }
}

public struct SessionDraft: Identifiable, Hashable {
    public var id: UUID
    public var date: Date
    public var training: TrainingDraft

    public init(id: UUID = UUID(), date: Date = .now, training: TrainingDraft) {
        self.id = id
        self.date = date
        self.training = training
    }

    init(from model: Session) {
        self.id = UUID()
        self.date = model.date
        self.training = TrainingDraft(from: model.training)
    }
}
