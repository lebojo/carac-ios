//
//  GlobalSettingsView.swift
//  carac
//
//  Created by Jordan on 08.03.2025.
//

import SwiftUI

struct GlobalSettingsView: View {
    @AppStorage("tintColor") var tintColor: Data?

    var body: some View {
        List {
            Text("TODO")
        }
    }
}

#Preview {
    GlobalSettingsView()
}
