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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.3).ignoresSafeArea()
                
                List {
                    ForEach(items) {task in
                        TaskRow(task: task)
                    }
                }.scrollContentBackground(.hidden)
            }.toolbar {
                ToolbarItem {
                    TopBarTitleWidget()
                }
            }.navigationTitle("Previous")
        }.onAppear() {
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
}
