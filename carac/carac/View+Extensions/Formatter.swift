//
//  Formatter.swift
//  carac
//
//  Created by Jordan Chap on 29.11.2025.
//

extension Double {
    func maxDigits(_ fractionDigits: Int = 2) -> String {
        self.formatted(.number.precision(.fractionLength(fractionDigits))).replacingOccurrences(of: ".00", with: "")
    }
}
