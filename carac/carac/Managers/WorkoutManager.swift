//
//  WorkoutManager.swift
//  carac
//
//  Created by Jordan Chap on 07.10.2026.
//

import Foundation
import HealthKit

/// Records a strength training workout in Apple Health / Fitness alongside a session.
/// iOS 26+: live workout session on iPhone. Older versions: workout saved at the end of the session.
@MainActor
final class WorkoutManager {
    static let isEnabledKey = "appleHealthWorkoutEnabled"
    static let isEnabledDefault = true

    private let healthStore = HKHealthStore()

    /// Identifies the current workout, so a start still in flight knows when it has been finished or cancelled.
    private var workoutID: UUID?
    private var startDate: Date?
    private var liveSession: HKWorkoutSession?
    private var liveBuilder: HKWorkoutBuilder?

    private var configuration: HKWorkoutConfiguration {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .traditionalStrengthTraining
        configuration.locationType = .indoor
        return configuration
    }

    nonisolated init() {}

    private var isEnabled: Bool {
        UserDefaults.standard.object(forKey: Self.isEnabledKey) as? Bool ?? Self.isEnabledDefault
    }

    func start() {
        cancel()

        guard isEnabled, HKHealthStore.isHealthDataAvailable() else { return }

        let id = UUID()
        workoutID = id

        Task {
            await start(id: id)
        }
    }

    /// Ends the current workout and saves it. Calls `onFailure` if it could not be saved.
    func finish(onFailure: @escaping () -> Void) {
        guard let startDate else {
            reset()
            return
        }

        let endDate = Date.now
        let session = liveSession
        let builder = liveBuilder
        reset()

        Task {
            if let session, let builder {
                session.end()

                do {
                    try await builder.endCollection(at: endDate)
                    try await builder.finishWorkout()
                    return
                } catch {
                    print("Failed to save live workout: \(error)")
                    builder.discardWorkout()
                }
            }

            do {
                try await saveWorkout(from: startDate, to: endDate)
            } catch {
                print("Failed to save workout: \(error)")
                onFailure()
            }
        }
    }

    func cancel() {
        if let liveSession, let liveBuilder {
            liveSession.end()
            liveBuilder.discardWorkout()
        }

        reset()
    }

    private func start(id: UUID) async {
        do {
            try await healthStore.requestAuthorization(
                toShare: [HKObjectType.workoutType(), HKQuantityType(.activeEnergyBurned)],
                read: [HKQuantityType(.activeEnergyBurned), HKQuantityType(.heartRate)]
            )
        } catch {
            print("HealthKit authorization failed: \(error)")
            return
        }

        guard workoutID == id,
              healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized
        else { return }

        let date = Date.now
        startDate = date

        guard #available(iOS 26.0, *) else { return }

        let session: HKWorkoutSession
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        } catch {
            print("Failed to create live workout: \(error)")
            return
        }

        let builder = session.associatedWorkoutBuilder()
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        session.startActivity(with: date)

        do {
            try await builder.beginCollection(at: date)
        } catch {
            // The workout will be saved at the end of the session instead.
            print("Failed to start live workout: \(error)")
            session.end()
            builder.discardWorkout()
            return
        }

        // Finished or cancelled while starting.
        guard workoutID == id else {
            session.end()
            builder.discardWorkout()
            return
        }

        liveSession = session
        liveBuilder = builder
    }

    private func saveWorkout(from startDate: Date, to endDate: Date) async throws {
        let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())
        try await builder.beginCollection(at: startDate)
        try await builder.endCollection(at: endDate)
        try await builder.finishWorkout()
    }

    private func reset() {
        workoutID = nil
        startDate = nil
        liveSession = nil
        liveBuilder = nil
    }
}
