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
        if #available(iOS 26.0, *) {
            if isFinished {
                Label(text, systemImage: systemImage)
            } else {
                Stepper(value: value, in: 0 ... 200, step: step) {
                    Label(text, systemImage: systemImage)
                }
            }
        } else {
            ZStack {
                Stepper("", value: value, in: 0 ... 200, step: step)
                    .opacity(isFinished ? 0 : 1)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .trailing)

                Label(text, systemImage: systemImage)
                    .lineLimit(1, reservesSpace: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
