//
//  Date+Extensions.swift
//  carac
//
//  Created by Jordan Chap on 09.01.2026.
//

import Foundation

extension Date {
    var twoDigitsHour: String {
        self.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits))
    }
}
