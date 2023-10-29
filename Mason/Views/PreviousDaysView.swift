//
//  PreviousDaysView.swift
//  Mason
//
//  Created by Alexius Academia on 10/19/23.
//

import SwiftUI
import SwiftData

struct PreviousDaysView: View {
    @Query private var tasks: [Task]
    
    @State private var items: [Task] = []
    @State private var taskUpdated = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.3).ignoresSafeArea()
                
                if items.count == 0 {
                    Text("No previous prending tasks.")
                } else {
                    List {
                        ForEach(items) {task in
                            TaskRow(task: task, showDate: true, taskChange: $taskUpdated)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button {
                                        let today = Date.now
                                        task.timestamp = today
                                        
                                        updateItems()
                                    }label: {
                                        Label("Move to today", systemImage: "sunrise")
                                    }
                                }))
                        }
                    }.scrollContentBackground(.hidden)
                }
            }.toolbar {
                ToolbarItem {
                    TopBarTitleWidget()
                }
            }.navigationTitle("Previous")
        }.onAppear() {
            updateItems()
        }
    }
    
    private func updateItems() {
        items = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let now = Date.now
        
        for task in tasks {
            let taskDate = task.timestamp
            
            if !Calendar.current.isDateInToday(taskDate) {
                if taskDate < now && !task.completed {
                    items.append(task)
                }
            }
        }
    }
}
