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

struct SessionDraft: Identifiable, Hashable {
    var id: UUID
    var date: Date
    var training: TrainingDraft
    let persistedSessionID: PersistentIdentifier?

    init(id: UUID = UUID(), date: Date = .now, training: TrainingDraft, persistedSessionID: PersistentIdentifier? = nil) {
        self.id = id
        self.date = date
        self.training = training
        self.persistedSessionID = persistedSessionID
    }

    init(from model: Session) {
        self.id = UUID()
        self.date = model.date
        self.training = TrainingDraft(from: model.training)
        self.persistedSessionID = model.persistentModelID
    }
}
