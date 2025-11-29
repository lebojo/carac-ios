//
//  HallOfGloryView.swift
//  carac
//
//  Created by Jordan Chap on 24.11.2025.
//

import SwiftUI

struct HallOfGloryView: View {
    let totalWeightPulled: Double

    var body: some View {
        VStack {
            Image(systemName: "trophy")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom)

            Text("Total weight pulled: **\(totalWeightPulled.maxDigits()) kg**")
        }
    }
}

#Preview {
    HallOfGloryView(totalWeightPulled: 123.13)
}
