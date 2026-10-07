//
//  ChevronRowButton.swift
//  carac
//
//  Created by Jordan on 07.10.2026.
//

import SwiftUI

struct ChevronRowButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .accessibilityHidden(true)
            }
        }
    }
}
