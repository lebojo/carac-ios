//
//  Session.swift
//  carac
//
//  Created by Jordan on 07.03.2025.
//

import Foundation
import SwiftData

typealias Session = SchemaV1.Session

extension Session {
    convenience init(from draft: SessionDraft) {
        self.init(
            date: draft.date,
            training: Training(from: draft.training)
        )
    }

    func update(with draft: SessionDraft) {
        date = draft.date
        training.update(with: draft.training)
    }
}
