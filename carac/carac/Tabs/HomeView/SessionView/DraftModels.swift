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
}

// MARK: - Materialization to SwiftData models

extension ExerciseSetDraft {
    func makeModel(idGenerator: inout Int) -> ExerciseSet {
        let model = ExerciseSet(id: idGenerator, reps: reps, weight: weight)
        idGenerator += 1
        return model
    }
}

extension ExerciseDraft {
    func makeModel() -> Exercise {
        var nextId = 1
        let setsModels = sets.map { $0.makeModel(idGenerator: &nextId) }
        return Exercise(name: name, weightSteps: weightSteps, sets: setsModels)
    }
}

extension TrainingDraft {
    func makeModel() -> Training {
        let exercisesModels = exercises.map { $0.makeModel() }
        let training = Training(title, exercises: exercisesModels, repeatDays: repeatDays.compactMap(RepeatDay.init(rawValue:)))
        return training
    }
}

extension SessionDraft {
    func makeModel() -> Session {
        let trainingModel = training.makeModel()
        return Session(date: date, training: trainingModel)
    }
}

extension ExerciseSetDraft {
    init(from model: ExerciseSet) {
        self.id = model.id
        self.reps = model.reps
        self.weight = model.weight
    }
}

extension ExerciseDraft {
    init(from model: Exercise) {
        self.id = UUID()
        self.name = model.name
        self.weightSteps = model.weightSteps
        self.sets = model.sets.map { ExerciseSetDraft(from: $0) }
    }
}

extension SessionDraft {
    init(from model: Session) {
        self.id = UUID()
        self.date = model.date
        self.training = TrainingDraft(from: model.training)
    }
}
