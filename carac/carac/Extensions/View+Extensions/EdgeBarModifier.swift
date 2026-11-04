import SwiftUI

extension View {
    func topBar<Bar: View>(@ViewBuilder content: () -> Bar) -> some View {
        modifier(EdgeBarModifier(edge: .top, bar: content()))
    }

    func bottomBar<Bar: View>(@ViewBuilder content: () -> Bar) -> some View {
        modifier(EdgeBarModifier(edge: .bottom, bar: content()))
    }
}

struct EdgeBarModifier<Bar: View>: ViewModifier {
    let edge: VerticalEdge
    let bar: Bar

    private var scrollEdge: Edge.Set {
        edge == .top ? .top : .bottom
    }

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .safeAreaBar(edge: edge) {
                    bar
                }
                .scrollEdgeEffectStyle(.soft, for: scrollEdge)
        } else {
            content
                .safeAreaInset(edge: edge, spacing: 0) {
                    bar
                        .background(.bar)
                }
        }
    }
}
