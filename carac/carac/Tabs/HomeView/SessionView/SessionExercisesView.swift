//
//  SessionExercisesView.swift
//  carac
//
//  Created by Jordan Chap on 26.12.2025.
//

import SwiftUI

struct SessionExercisesView: View {
    @Binding var exercises: [ExerciseDraft]
    @State private var isShowingAddExercise: Bool = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach($exercises) { exercise in
                    NavigationView {
                        ExerciseDraftView(exercise: exercise)
                    }
                    .containerRelativeFrame(.horizontal)
                }

                NavigationView {
                    VStack(spacing: 20) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(Color.accentColor)
                        
                        Text("Add Exercise")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Tap to add a new exercise to this session.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button {
                            isShowingAddExercise = true
                        } label: {
                            Label("Add Exercise", systemImage: "plus")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: 200)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .caracBackground()
                    .navigationTitle("New Exercise")
                }
                .containerRelativeFrame(.horizontal)
            }
            .scrollTargetLayout()
        }
        .caracBackground()
        .scrollTargetBehavior(.viewAligned)
        .modifier(NextPageDiscoveryViewModifier())
        .sheet(isPresented: $isShowingAddExercise) {
            AddExerciseToSessionSheetView(exercises: $exercises)
        }
    }
}

#Preview {
    SessionExercisesView(
        exercises: .constant([sampleExerciseDraft, sampleExerciseDraft, sampleExerciseDraft])
    )
}
