//
//  OnBoardingModifier.swift
//  carac
//
//  Created by Jordan on 05.03.2025.
//

import SwiftUI

public extension View {
    func onBoarding(isPresented: Bool) -> some View {
        modifier(OnBoardingModifier(isPresented: isPresented))
    }
}

struct OnBoardingModifier: ViewModifier {
    @EnvironmentObject var mainViewState: MainViewState

    @State private var isOnboardingShown = false

    let isPresented: Bool

    func body(content: Content) -> some View {
        content
            .onAppear {
                isOnboardingShown = isPresented
            }
            .sheet(isPresented: $isOnboardingShown) {
                VStack {
                    Image("carac")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)

                    Text("Hey, welcome to Carac!")
                        .font(.title)
                        .padding()

                    Button {
                        mainViewState.selectedState = .createTraining
                        isOnboardingShown = false
                    } label: {
                        Label("Create a Training", systemImage: "plus")
                    }
                }
            }
    }
}
