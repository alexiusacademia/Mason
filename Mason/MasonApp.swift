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
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
                } else {
                    Launchscreen().padding(25.0)
                }
            }.onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
            
        }
        .modelContainer(sharedModelContainer)
    }
}
