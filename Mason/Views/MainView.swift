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
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @State private var showAddTaskDialog = false
    

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    SummaryCard(
                        title: "Today",
                        count: taskViewModel.todayTasks.count,
                        emptyMessage: "No tasks for today.",
                        backgroundColor: Color.orange.opacity(0.5)
                    ) {
                        selectedTab = Tag.today
                    }
                    
                    SummaryCard(
                        title: "Previous",
                        count: taskViewModel.previousIncompleteTasks.count,
                        emptyMessage: "No pending previous tasks.",
                        backgroundColor: Color.blue.opacity(0.5)
                    ) {
                        selectedTab = Tag.previous
                    }
                    
                    SummaryCard(
                        title: "Weekly",
                        count: taskViewModel.weeklyTasks.count,
                        emptyMessage: "No tasks for this week",
                        backgroundColor: Color.green.opacity(0.5)
                    ) {
                        selectedTab = Tag.weekly
                    }
                }
            }
            .standardToolbar(showAddButton: true, addAction: { showAddTaskDialog = true })
            .sheet(isPresented: $showAddTaskDialog) {
                AddTaskDialogView(showMe: $showAddTaskDialog)
            }
        }
    }
}
