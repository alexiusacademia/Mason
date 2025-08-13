//
//  MasonApp.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI
import SwiftData

@main
struct MasonApp: App {
    @State private var isActive = false
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var accessibilityManager = AccessibilityManager()
    @StateObject private var hapticManager = HapticManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Task.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            VStack {
                if isActive {
                    ContentView()
                        .environmentObject(taskViewModel)
                        .environmentObject(accessibilityManager)
                        .environmentObject(hapticManager)
                } else {
                    Launchscreen()
                        .padding(25.0)
                        .environmentObject(accessibilityManager)
                        .environmentObject(hapticManager)
                }
            }
            .onAppear() {
                // Configure the task view model with the model context
                taskViewModel.configure(with: sharedModelContainer.mainContext)
                
                // Announce app launch for VoiceOver users
                if accessibilityManager.isVoiceOverEnabled {
                    AccessibilityUtils.announce("Mason task manager launched")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let shouldAnimate = !accessibilityManager.isReduceMotionEnabled
                    
                    if shouldAnimate {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isActive = true
                        }
                    } else {
                        isActive = true
                    }
                    
                    // Announce screen change for accessibility
                    if accessibilityManager.isVoiceOverEnabled {
                        AccessibilityUtils.announceScreenChange()
                    }
                }
            }
            
        }
        .modelContainer(sharedModelContainer)
    }
}
