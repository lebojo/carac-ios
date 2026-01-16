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
        sessionDraft: SessionDraft,
        type: EndSessionAlertViewModifier.EndSessionType
    ) -> some View {
        modifier(EndSessionAlertViewModifier(isPresented: isPresented, sessionDraft: sessionDraft, type: type))
    }
}

struct EndSessionAlertViewModifier: ViewModifier {
    @EnvironmentObject private var mainViewState: MainViewState

    @Environment(\.modelContext) var modelContext

    @Binding var isPresented: Bool

    let sessionDraft: SessionDraft
    let type: EndSessionType

    var isModifiying: Bool {
        sessionDraft.persistedSession != nil
    }

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(type.title),
                    message: Text(type.message),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(
                        Text(type.actionTitle),
                        action: {
                            guard type != .cancel else {
                                mainViewState.backHome()
                                return
                            }

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

    enum EndSessionType {
        case save
        case modify
        case cancel

        var title: String {
            switch self {
                case .save:
                    "Save session?"
                case .modify:
                    "Modify session?"
                case .cancel:
                    "Cancel session?"
            }
        }

        var message: String {
            switch self {
                case .save:
                    "Terminate the session now and save all your stats ?"
                case .modify:
                    "All data will be modified.\nThis cannot be undone."
                case .cancel:
                    "All data will be lost.\nThis cannot be undone."
            }
        }

        var actionTitle: String {
            switch self {
                case .save, .modify:
                    "Save"
                case .cancel:
                    "Confirm"
            }
        }
    }
}
