//
//  DeviceTheme.swift
//  carac
//
//  Created by Jordan Chap on 19.01.2026.
//

import SwiftUI

enum DeviceTheme: String, Codable, CaseIterable {
    case systemDefault
    case light
    case dark

    var colorScheme: ColorScheme? {
        switch self {
            case .systemDefault:
                return nil
            case .light:
                return .light
            case .dark:
                return .dark
        }
    }

    var title: String {
        switch self {
            case .systemDefault:
                return "System default"
            case .light:
                return "Light"
            case .dark:
                return "Dark"
        }
    }
}
