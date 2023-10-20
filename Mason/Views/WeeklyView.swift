//
//  WeeklyView.swift
//  Mason
//
//  Created by Alexius Academia on 10/19/23.
//

import SwiftUI
import SwiftData

struct WeeklyView: View {
    @Query private var tasks: [Task]
    
    @State private var items: [Task] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.opacity(0.3).ignoresSafeArea()
                
                List {
                    ForEach(items) { task in
                        TaskRow(task: task, showDate: true)
                    }
                }.scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem {
                    TopBarTitleWidget()
                }
            }
            .navigationTitle("Weekly")
        }.onAppear() {
            items = []
            
            let currentDate = Date.now
            let currentWeek = Calendar.current.component(.weekOfYear, from: currentDate)
            
            for task in tasks {
                if Calendar.current.component(.weekOfYear, from: task.timestamp) == currentWeek {
                    items.append(task)
                }
            }
        }
        
    }
}
