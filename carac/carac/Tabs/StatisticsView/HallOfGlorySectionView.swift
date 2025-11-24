//
//  HallOfGloryView.swift
//  carac
//
//  Created by Jordan Chap on 24.11.2025.
//

import SwiftUI

struct HallOfGlorySectionView: View {
    let totalWeightPulled: Double

    var body: some View {
        Section("Hall of glory") {
            VStack {
                Image(systemName: "trophy")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text("Total weight pulled: **\(totalWeightPulled.formatted()) kg**")
            }
        }
    }
}

#Preview {
    HallOfGlorySectionView(totalWeightPulled: 123.45)
}
