//
//  OnBoardingModifier.swift
//  carac
//
//  Created by Jordan on 05.03.2025.
//

import CoreData
import SwiftData
import SwiftUI

public extension View {
    func onBoarding(isPresented: Binding<Bool>) -> some View {
        modifier(OnBoardingModifier(isPresented: isPresented))
    }
}

struct OnBoardingModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                OnBoardingSheetContent(isPresented: $isPresented)
            }
    }
}

private struct OnBoardingSheetContent: View {
    @EnvironmentObject var mainViewState: MainViewState

    @Query(firstTrainingDescriptor) private var existingTrainings: [Training]

    @State private var isFetchingFromICloud = false

    @Binding var isPresented: Bool

    private static var firstTrainingDescriptor: FetchDescriptor<Training> {
        var descriptor = FetchDescriptor<Training>()
        descriptor.fetchLimit = 1
        return descriptor
    }

    var body: some View {
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
            VStack(spacing: 16) {
                Button {
                    mainViewState.selectedState = .createTraining
                    isPresented = false
                } label: {
                    Label("Create a Training", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)

                if isFetchingFromICloud {
                    ProgressView("Looking for your iCloud data…")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .interactiveDismissDisabled()
        .onChange(of: existingTrainings.isEmpty, initial: true) { _, isEmpty in
            if !isEmpty {
                isPresented = false
            }
        }
        .onReceive(
            NotificationCenter.default
                .publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
                .receive(on: RunLoop.main)
        ) { notification in
            guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event,
                  event.type != .export
            else { return }

            isFetchingFromICloud = event.endDate == nil
        }
    }
}
