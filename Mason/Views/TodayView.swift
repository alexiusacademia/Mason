//
//  TodayView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Query private var tasks: [Task]
    
    @State private var items: [Task] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.3).ignoresSafeArea()
                
                List {
                    ForEach(tasks) { task in
                        TaskRow(task: task)
                    }
                }.scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem {
                    TopBarTitleWidget()
                }
            }
            .navigationTitle("Today")
        }.onAppear() {
            for task in tasks {
                if task.timestamp == .now {
                    items.append(task)
                }
            }
        }
    }
}
