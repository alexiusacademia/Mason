//
//  TodayView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var tasks: [Task]
    
    @State private var items: [Task] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.3).ignoresSafeArea()
                
                List {
                    ForEach(items) { task in
                        TaskRow(task: task)
                    }
                    .onDelete(perform: deleteItems)
                }.scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem {
                    TopBarTitleWidget()
                }
            }
            .navigationTitle("Today")
        }.onAppear() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            let now = dateFormatter.string(from: Date.now)
            
            for task in tasks {
                let taskDate = dateFormatter.string(from: task.timestamp)
                
                if taskDate == now {
                    items.append(task)
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
            for index in offsets {
                print(index)
            }
            
            withAnimation {
                for index in offsets {
                    modelContext.delete(tasks[index])
                }
            }
        }
}
