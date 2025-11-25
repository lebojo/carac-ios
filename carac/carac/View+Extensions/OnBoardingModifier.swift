//
//  OnBoardingModifier.swift
//  carac
//
//  Created by Jordan on 05.03.2025.
//

import SwiftUI

public extension View {
    func onBoarding(isPresented: Binding<Bool>) -> some View {
        modifier(OnBoardingModifier(isPresented: isPresented))
    }
}

struct OnBoardingModifier: ViewModifier {
    @EnvironmentObject var mainViewState: MainViewState

    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                VStack {
                    Image("carac")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)

                    Text("Hey, welcome to Carac!")
                        .font(.title)
                        .padding()
                    Text("To start your journey, simply create a training.\n💪")
                        .font(.subheadline)
                }
                .safeAreaInset(edge: .bottom) {
                    Button {
                        mainViewState.selectedState = .createTraining
                        isPresented = false
                    } label: {
                        Label("Create a Training", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .interactiveDismissDisabled()
            }
    }
}
