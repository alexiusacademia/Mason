//
//  WeeklyView.swift
//  Mason
//
//  Created by Alexius Academia on 10/19/23.
//

import SwiftUI
import SwiftData

struct WeeklyView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [Task]
    
    @State private var items: [Task] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.opacity(0.3).ignoresSafeArea()
                
                if items.count == 0 {
                    Text("No tasks for this week.")
                } else {
                    List {
                        ForEach(items) { task in
                            TaskRow(task: task, showDate: true)
                        }.onDelete(perform: deleteItems)
                    }.scrollContentBackground(.hidden)
                }
            }
            .toolbar {
                ToolbarItem {
                    TopBarTitleWidget()
                }
            }
            .navigationTitle("Weekly")
        }.onAppear() {
            updateItems()
        }
    }
    
    private func updateItems() {
        items = []
        
        let currentDate = Date.now
        let currentWeek = Calendar.current.component(.weekOfYear, from: currentDate)
        
        for task in tasks {
            if Calendar.current.component(.weekOfYear, from: task.timestamp) == currentWeek {
                items.append(task)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let task = (items[index])
                
                modelContext.delete(task)
            }
        }
    }
}
