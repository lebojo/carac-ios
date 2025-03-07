//
//  ContentView.swift
//  carac
//
//  Created by Jordan on 02.03.2025.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    @EnvironmentObject var mainViewState: MainViewState

    @Query private var exercises: [Exercise]

    var todayExercises: [Exercise] {
        exercises.filter { $0.days.contains(RepeatDay.today.rawValue) }
    }

    var restOfTheWeekExercises: [Exercise] {
        exercises.filter { !$0.days.contains(RepeatDay.today.rawValue) }
    }

    var body: some View {
        NavigationStack(path: $mainViewState.mainPath) {
            List {
                Section("Today") {
                    if todayExercises.isEmpty {
                        ContentUnavailableView(
                            "No exercises today",
                            systemImage: "figure.walk.motion.trianglebadge.exclamationmark",
                            description: Text("\(RepeatDay.today.rawValue)")
                        )
                    } else {
                        Button {
                            let session = Session(exercises: todayExercises)
                            modelContext.insert(session)
                            mainViewState.mainPath.append(session)
                        } label: {
                            Text("Today exercices: \(todayExercises.count)")
                        }
                    }
                }

                if !restOfTheWeekExercises.isEmpty {
                    Section("This week") {
                        Text("TODO")
                    }
                }
            }
            .navigationTitle("Carac Home")
            .toolbar {
                Button {
                    mainViewState.mainPath.append(MainState.createExercise)
                } label: {
                    Label("Create an exercise", systemImage: "plus")
                }
            }
            .navigationDestination(for: MainState.self) { state in
                switch state {
                case .createExercise:
                    CreateAnExerciseView()
                }
            }
            .navigationDestination(for: Session.self, destination: { session in
                SessionView(session: session)
            })
            .onBoarding(isPresented: exercises.isEmpty) // TODO: Change to UserDefaults
        }
    }

    private func addItem() {
        withAnimation {
//            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(exercises[index])
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Exercise.self, inMemory: true)
        .environmentObject(sampleMainViewState)
}
