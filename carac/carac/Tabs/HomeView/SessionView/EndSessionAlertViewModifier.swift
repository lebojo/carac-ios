//
//  EndSessionAlertViewModifier.swift
//  carac
//
//  Created by Jordan Chap on 03.11.2025.
//

import SwiftUI

extension View {
    func endSessionAlert(
        isPresented: Binding<Bool>,
        sessionDraft: SessionDraft
    ) -> some View {
        modifier(EndSessionAlertViewModifier(isPresented: isPresented, sessionDraft: sessionDraft))
    }
}

struct EndSessionAlertViewModifier: ViewModifier {
    @EnvironmentObject private var mainViewState: MainViewState

    @Environment(\.modelContext) var modelContext

    @Binding var isPresented: Bool

    let sessionDraft: SessionDraft

    var isModifiying: Bool {
        sessionDraft.persistedSession != nil
    }

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(isModifiying ? "Modify session?" : "Save session?"),
                    message: Text(
                        isModifiying ? "All data will be modified. This cannot be undone." : "Terminate the session now and save all your stats ?"
                    ),
                    primaryButton: .cancel(),
                    secondaryButton: .default(
                        Text("Save"),
                        action: {
                            saveSession(sessionModel: sessionDraft.persistedSession)
                        }
                    )
                )
            }
    }

    @MainActor
    private func saveSession(sessionModel: Session?) {
        if let sessionModel {
            sessionModel.update(with: sessionDraft)
        } else {
            let sessionSave = Session(from: sessionDraft)
            modelContext.insert(sessionSave)
        }

        do {
            try modelContext.save()
            mainViewState.backHome()
        } catch {
            print("Failed to save session")
        }
    }
}
