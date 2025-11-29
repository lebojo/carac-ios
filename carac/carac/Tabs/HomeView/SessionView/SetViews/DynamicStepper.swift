//
//  DynamicStepper.swift
//  carac
//
//  Created by Jordan Chap on 29.11.2025.
//

import SwiftData
import SwiftUI

struct DynamicStepper: View {
    let value: Binding<Double>
    let step: Double

    let text: String
    let systemImage: String

    let isFinished: Bool

    var body: some View {
        HStack {
            Label(text, systemImage: systemImage)
                .frame(maxWidth: .infinity, alignment: .leading)
            if !isFinished {
                Stepper("", value: value, in: 0 ... 200, step: step)
            }
        }
    }
}
