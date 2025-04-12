//
//  HelpUsSection.swift
//  carac
//
//  Created by Jordan on 12.04.2025.
//

import StoreKit
import SwiftUI

struct HelpUsSection: View {
    var body: some View {
        Section {
            Button("Rate the app", systemImage: "star.fill") {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
            .foregroundStyle(.green)
            Button("Report a bug", systemImage: "ladybug.fill") {
                if let url = URL(string: "https://github.com/lebojo/carac-ios/issues/new/choose") {
                    UIApplication.shared.open(url)
                }
            }
            .foregroundStyle(.red)
        } header: {
            Text("Help us")
        }
        footer: {
            Text("It's the best way to help us ❤️")
        }
    }
}

#Preview {
    List {
        HelpUsSection()
    }
}
