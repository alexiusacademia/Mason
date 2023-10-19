//
//  ContentView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .overlay {
                            RoundedRectangle(cornerRadius: 15.0)
                                .stroke(lineWidth: 1.0)
                        }
                }
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sunrise")
                }
            PreviousDaysView()
                .tabItem {
                    Label("Previous", systemImage: "arrowshape.turn.up.backward")
                }
            WeeklyView()
                .tabItem {
                    Label("Weekly", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
