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
        let templates = Array(Set(sessionJTOs.compactMap(\.training).map(\.template)))

        self.init(savingDate: date, templates: Array(templates), sessions: sessionJTOs)
    }
}
