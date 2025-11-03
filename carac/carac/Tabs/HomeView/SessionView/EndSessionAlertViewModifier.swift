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

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text("End session"),
                    message: Text(
                        "Terminate the session now and save all your stats ?"
                    ),
                    primaryButton: .cancel(),
                    secondaryButton: .default(
                        Text("Save"),
                        action: {
                            let sessionSave = Session(from: sessionDraft)
                            modelContext.insert(sessionSave)
                            do {
                                try modelContext.save()
                                mainViewState.currentSession = nil
                            } catch {
                                print("Failed to save session")
                            }
                        }
                    )
                )
            }
    }
}
