//
//  ContentView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI
import SwiftData

enum Tag {
    case main
    case today
    case previous
    case weekly
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var selectedTab = Tag.main

    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .overlay {
                            RoundedRectangle(cornerRadius: 15.0)
                                .stroke(lineWidth: 1.0)
                        }
                }.tag(Tag.main)
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sunrise")
                }
                .tag(Tag.today)
            PreviousDaysView()
                .tabItem {
                    Label("Previous", systemImage: "arrowshape.turn.up.backward")
                }.tag(Tag.previous)
            WeeklyView()
                .tabItem {
                    Label("Weekly", systemImage: "calendar")
                }.tag(Tag.weekly)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
