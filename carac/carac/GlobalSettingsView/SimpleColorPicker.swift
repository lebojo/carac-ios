//
//  MemoryColorPicker.swift
//  carac
//
//  Created by Jordan on 16.03.2025.
//

import SwiftUI

struct SimpleColorPicker: View {
    @Binding var selection: Color

    let colors: [Color] = [.red, .green, .blue, .yellow, .orange]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Tint color")
            HStack {
                ForEach(colors, id: \.self) { color in
                    Button {
                        withAnimation {
                            selection = color
                        }
                    } label: {
                        Circle()
                            .fill(color)
                            .clipShape(Circle())
                            .overlay {
                                if color.hex == selection.hex {
                                    Circle().stroke(.black, lineWidth: 3)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}
