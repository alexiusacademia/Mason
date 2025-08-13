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
                VStack(spacing: 20) {
                    // Modern header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(greeting)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Let's get things done")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Modern summary cards
                    VStack(spacing: 16) {
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
                            emptyMessage: "No weekly tasks.", 
                            backgroundColor: Color.green.opacity(0.5)
                        ) {
                            selectedTab = Tag.weekly
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 20)
                }
            }
            .background(Color(.systemGroupedBackground))
            .standardToolbar(showAddButton: true, addAction: { showAddTaskDialog = true })
            .sheet(isPresented: $showAddTaskDialog) {
                AddTaskDialogView(showMe: $showAddTaskDialog)
            }
        }
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
}
