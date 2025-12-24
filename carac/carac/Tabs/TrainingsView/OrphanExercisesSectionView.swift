//
//  OrphanExercisesView.swift
//  carac
//
//  Created by Jordan Chap on 22.12.2025.
//

import SwiftData
import SwiftUI

struct OrphanExercisesSectionView: View {
    @Query var sessions: [Session]

    let correctExercisesName: [String]

    private var orphanExercises: [Exercise] {
        sessions.flatMap(\.training.exercises).filter { exercise in
            !correctExercisesName.contains(exercise.name)
        }
    }

    var body: some View {
        if !orphanExercises.isEmpty {
            Section("Orphan exercises") {
                ForEach(orphanExercises, id: \.persistentModelID) { exercise in
                    Button {
                        // TODO: Implement handling of orphan exercise selection.
                    } label: {
                        HStack {
                            Text(exercise.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    List {
        OrphanExercisesSectionView(correctExercisesName: [])
    }
}
