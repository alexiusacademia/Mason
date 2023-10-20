//
//  MainView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Binding var selectedTab: Tag
    @Query private var tasks: [Task]
    
    @State private var showAddTaskDialog = false
    
    @State var todayTasks = "0"
    @State var previousIncompleteTasks = "0"
    @State var weeklyTasks = "0"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Button {
                        selectedTab = Tag.today
                    }label: {
                        SummaryTile(title: "Today", subtitle: $todayTasks, bgColor: Color.orange.opacity(0.5))
                            .padding()
                    }
                    
                    Button {
                        selectedTab = Tag.previous
                    }label: {
                        SummaryTile(title: "Previous", subtitle: $previousIncompleteTasks, bgColor: Color.blue.opacity(0.5))
                            .padding()
                    }
                    
                    Button {
                        selectedTab = Tag.weekly
                    }label: {
                        SummaryTile(title: "Weekly", subtitle: $weeklyTasks, bgColor: Color.green.opacity(0.5))
                            .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    TopBarTitleWidget()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddTaskDialog = true
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }.sheet(isPresented: $showAddTaskDialog, content: {
                AddTaskDialogView(showMe: $showAddTaskDialog)
            })
        }.onAppear() {
            var today = 0
            var previousIncomplete = 0
            var weeklyTasks = 0
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let now = dateFormatter.string(from: Date.now)
            
            for task in tasks {
                let taskDate = dateFormatter.string(from: task.timestamp)
                
                if taskDate == now {
                    today += 1
                }
                
                if !Calendar.current.isDateInToday(task.timestamp) {
                    if taskDate < now && !task.completed {
                        previousIncomplete += 1
                    }
                }
                
                let currentDate = Date.now
                let currentWeek = Calendar.current.component(.weekOfYear, from: currentDate)
                
                if Calendar.current.component(.weekOfYear, from: task.timestamp) == currentWeek {
                    weeklyTasks += 1
                }
            }

            self.todayTasks = today == 0 ? "No tasks for today." : String(today)
            self.previousIncompleteTasks = previousIncomplete == 0 ? "No pending previous tasks." : String(previousIncomplete)
            self.weeklyTasks = weeklyTasks == 0 ? "No tasks for this week" :  String(weeklyTasks)
        }
    }
}
