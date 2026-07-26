//
//  ExercisePickerView.swift
//  carac
//
//  Created by Killian Mathias on 25.07.2026.
//

import SwiftData
import SwiftUI

struct ExercisePickerView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(filter: #Predicate<Exercise> { $0.sets.isEmpty })
    private var allExercises: [Exercise]

    @Binding var trainingExercises: [Exercise]

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
        VStack(spacing: 0) {
            // Type Filter Pills
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

                Section("Available exercises (\(filteredExercises.count))") {
                    if filteredExercises.isEmpty {
                        ContentUnavailableView(
                            "No exercises found",
                            systemImage: "dumbbell",
                            description: Text("Create a new exercise or try a different search.")
                        )
                    } else {
                        ForEach(filteredExercises) { exercise in
                            ExercisePickerRow(exercise: exercise, trainingExercises: $trainingExercises)
                        }
                    }
                }
            }
            .caracListStyle()
            .searchable(text: $searchText, prompt: "Search exercise...")
        }
        .navigationTitle("Select Exercises")
        .sheet(isPresented: $isShowingCreateExercise) {
            CreateAnExerciseSheetView(isPresented: $isShowingCreateExercise) { newExercise in
                if !trainingExercises.contains(where: { $0.id == newExercise.id }) {
                    trainingExercises.append(newExercise)
                }
            }
        }
    }
}

struct ExercisePickerRow: View {
    let exercise: Exercise
    @Binding var trainingExercises: [Exercise]

    private var isSelected: Bool {
        trainingExercises.contains(where: { $0.id == exercise.id })
    }

    private var exerciseTypeEnum: ExerciseType {
        ExerciseType(rawValue: exercise.exerciseType) ?? .strength
    }

    private var equipmentEnum: EquipmentType {
        EquipmentType(rawValue: exercise.equipment) ?? .other
    }

    var body: some View {
        Button {
            if let index = trainingExercises.firstIndex(where: { $0.id == exercise.id }) {
                trainingExercises.remove(at: index)
            } else {
                trainingExercises.append(exercise)
            }
        } label: {
            HStack {
                Image(systemName: exerciseTypeEnum.systemImage)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(exercise.name)
                        .foregroundStyle(.primary)
                    Text("\(equipmentEnum.title) • \(exerciseTypeEnum.title)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary.opacity(0.4))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ExercisePickerView(trainingExercises: .constant([]))
    }
}
