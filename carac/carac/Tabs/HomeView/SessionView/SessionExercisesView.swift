//
//  SessionExercisesView.swift
//  carac
//
//  Created by Jordan Chap on 26.12.2025.
//

import SwiftUI

struct SessionExercisesView: View {
    @Binding var exercises: [ExerciseDraft]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach($exercises) { exercise in
                    NavigationView {
                        ExerciseDraftView(exercise: exercise)
                    }
                    .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
    }
}

#Preview {
    SessionExercisesView(
        exercises: .constant([sampleExerciseDraft, sampleExerciseDraft, sampleExerciseDraft])
    )
}
