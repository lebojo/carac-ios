import Foundation
import SwiftData

public struct ExerciseSetDraft: Identifiable, Hashable {
    public var id: Int
    public var reps: Int
    public var weight: Double
    public var duration: Double?
    public var distance: Double?

    public init(id: Int, reps: Int = 10, weight: Double = 1.0, duration: Double? = nil, distance: Double? = nil) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.duration = duration
        self.distance = distance
    }

    init(from model: ExerciseSet) {
        self.id = model.id
        self.reps = model.reps
        self.weight = model.weight
        self.duration = model.duration
        self.distance = model.distance
    }
}

public struct ExerciseDraft: Identifiable, Hashable {
    public var id: UUID
    public var name: String
    public var weightSteps: Double
    public var equipment: String
    public var exerciseType: String
    public var sets: [ExerciseSetDraft]

    public init(id: UUID = UUID(), name: String, weightSteps: Double = 1.0, equipment: String = EquipmentType.other.rawValue, exerciseType: String = ExerciseType.strength.rawValue, sets: [ExerciseSetDraft] = []) {
        self.id = id
        self.name = name
        self.weightSteps = weightSteps
        self.equipment = equipment
        self.exerciseType = exerciseType
        self.sets = sets
    }

    init(from model: Exercise) {
        self.id = UUID()
        self.name = model.name
        self.weightSteps = model.weightSteps
        self.equipment = model.equipment
        self.exerciseType = model.exerciseType
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
    let persistedSession: Session?

    init(id: UUID = UUID(), date: Date = .now, training: TrainingDraft, persistedSession: Session? = nil) {
        self.id = id
        self.date = date
        self.training = training
        self.persistedSession = persistedSession
    }

    init(from model: Session) {
        self.id = UUID()
        self.date = model.date
        self.training = TrainingDraft(from: model.training)
        self.persistedSession = model
    }

    var title: String {
        training.title
    }

    var exercisesCount: Int {
        training.exercises.count
    }

    var totalSetsCount: Int {
        training.exercises.reduce(0) { $0 + $1.sets.count }
    }

    var totalWeightPulled: Double {
        training.exercises.reduce(0) { total, exercise in
            total + exercise.sets.reduce(0) { total, set in
                total + (set.weight * Double(set.reps))
            }
        }
    }
}
