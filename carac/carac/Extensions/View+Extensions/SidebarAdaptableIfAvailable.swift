//
//  SidebarAdaptableIfAvailable.swift
//  carac
//
//  Created by Jordan on 12.04.2025.
//

import SwiftUI

extension View {
    func sideBarAdaptableIfAvailable() -> some View {
        modifier(SidebarAdaptableIfAvailable())
    }
}

struct SidebarAdaptableIfAvailable: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .tabViewStyle(.sidebarAdaptable)
        } else {
            content
        }
    }
}
