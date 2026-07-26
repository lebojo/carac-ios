//
//  AddExerciseToSessionSheetView.swift
//  carac
//
//  Created by Jordan Chap on 25.07.2026.
//

import SwiftData
import SwiftUI

struct AddExerciseToSessionSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(filter: #Predicate<Exercise> { $0.sets.isEmpty })
    private var allExercises: [Exercise]

    @Binding var exercises: [ExerciseDraft]

    @State private var searchText: String = ""
    @State private var selectedType: ExerciseType? = nil
    @State private var isShowingCreateExercise: Bool = false

    private var filteredExercises: [Exercise] {
        allExercises.filter { exercise in
            let matchesSearch = searchText.isEmpty || exercise.name.localizedCaseInsensitiveContains(searchText)
            let matchesType = selectedType == nil || exercise.exerciseType == selectedType?.rawValue
            return matchesSearch && matchesType
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button {
                            selectedType = nil
                        } label: {
                            Text("All")
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedType == nil ? Color.accentColor : Color.secondary.opacity(0.15))
                                .foregroundStyle(selectedType == nil ? .white : .primary)
                                .clipShape(Capsule())
                        }

                        ForEach(ExerciseType.allCases) { type in
                            Button {
                                selectedType = (selectedType == type) ? nil : type
                            } label: {
                                Label(type.title, systemImage: type.systemImage)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedType == type ? Color.accentColor : Color.secondary.opacity(0.15))
                                    .foregroundStyle(selectedType == type ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                List {
                    Section {
                        Button {
                            isShowingCreateExercise = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(.tint)
                                Text("Create new exercise")
                                    .fontWeight(.medium)
                            }
                        }
                    }

                    Section("Available exercises") {
                        if filteredExercises.isEmpty {
                            ContentUnavailableView(
                                "No exercises found",
                                systemImage: "dumbbell",
                                description: Text("Create a new exercise or try a different search.")
                            )
                        } else {
                            ForEach(filteredExercises) { exercise in
                                Button {
                                    addExerciseToSession(exercise)
                                } label: {
                                    HStack {
                                        let type = ExerciseType(rawValue: exercise.exerciseType) ?? .strength
                                        let eq = EquipmentType(rawValue: exercise.equipment) ?? .other

                                        Image(systemName: type.systemImage)
                                            .foregroundStyle(.secondary)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(exercise.name)
                                                .foregroundStyle(.primary)
                                            Text("\(eq.title) • \(type.title)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                        Image(systemName: "plus.circle")
                                            .font(.title2)
                                            .foregroundStyle(Color.accentColor)
                                    }
                                }
                            }
                        }
                    }
                }
                .caracListStyle()
                .searchable(text: $searchText, prompt: "Search exercise...")
            }
            .navigationTitle("Add Exercise to Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $isShowingCreateExercise) {
                CreateAnExerciseSheetView(isPresented: $isShowingCreateExercise) { newExercise in
                    addExerciseToSession(newExercise)
                }
            }
        }
    }

    private func addExerciseToSession(_ exercise: Exercise) {
        var draft = ExerciseDraft(from: exercise)
        // Ensure default sets are ready if empty
        if draft.sets.isEmpty {
            if draft.exerciseType == ExerciseType.cardio.rawValue {
                draft.sets.append(ExerciseSetDraft(id: 0, duration: 15.0, distance: 3.0))
            } else {
                draft.sets.append(ExerciseSetDraft(id: 0, reps: 10, weight: draft.weightSteps))
            }
        }
        exercises.append(draft)
        dismiss()
    }
}

#Preview {
    AddExerciseToSessionSheetView(exercises: .constant([]))
}
