//
//  GlobalJTO.swift
//  carac
//
//  Created by Jordan Chap on 23.01.2026.
//

import Foundation

struct GlobalJTO: Codable {
    let savingDate: Date
    let trainingTemplates: [TrainingJTO]
    let sessions: [SessionJTO]

    private init(savingDate: Date, templates: [TrainingJTO], sessions: [SessionJTO]) {
        self.savingDate = savingDate
        self.trainingTemplates = templates
        self.sessions = sessions
    }

    init(date: Date = .now, sessions: [Session]) {
        let sessionJTOs: [SessionJTO] = sessions.map { SessionJTO(from: $0) }
        let templates = Array(Set(sessions.map { TrainingJTO(from: $0.training).template }))

        self.init(savingDate: date, templates: templates, sessions: sessionJTOs)
    }

    var persistedSessions: [Session] {
        sessions.map(\.persistedModel)
    }

    var persistedTemplates: [Training] {
        trainingTemplates.map(\.persistedModel)
    }
}
