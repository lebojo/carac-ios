//
//  OrphanExercisesCorrectionSheetView.swift
//  carac
//
//  Created by Jordan Chap on 31.12.2025.
//

import SwiftData
import SwiftUI

struct OrphanExercisesCorrectionSheetView: View {
    @Query private var exercises: [Exercise]

    @State private var selectedCorrectExercise: String?
    @State private var showConfirmation: Bool = false

    let wrongExerciseName: String
    let correctExercisesName: [String]

    var body: some View {
        List {
            HStack {
                Text("\(wrongExerciseName)")

                Image(systemName: "arrowshape.right.fill")
                    .foregroundStyle(.tint)
                    .frame(maxWidth: .infinity)

                Menu(selectedCorrectExercise ?? "No exercises") {
                    ForEach(correctExercisesName, id: \.self) { name in
                        Button(name) {
                            selectedCorrectExercise = name
                        }
                    }
                }
            }
            .onAppear {
                selectedCorrectExercise = correctExercisesName.first
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button("Transfer to correct exercise") {
                showConfirmation = true
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("Confirm the changes ?"),
                    message: Text("Merge the \(wrongExerciseName) into \(selectedCorrectExercise ?? "Unknown").\n⚠️ This action is not reversible ⚠️"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(
                        Text("Confirm"),
                        action: fixExerciseName
                    )
                )
            }
        }
    }

    private func fixExerciseName() {
        guard let selectedCorrectExercise else { return }

        exercises.filter { $0.name == wrongExerciseName }
            .forEach { $0.name = selectedCorrectExercise }
    }
}

#Preview {
    OrphanExercisesCorrectionSheetView(wrongExerciseName: "Pul up", correctExercisesName: ["Pull up", "Test ices"])
}
