//
//  TodayView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var showAddTaskDialog = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search today's tasks...", text: searchTextBinding)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Task list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if taskViewModel.filteredTodayTasks.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "sun.max")
                                    .font(.system(size: 48))
                                    .foregroundColor(.orange)
                                
                                Text(emptyMessage)
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                if taskViewModel.todaySearchText.isEmpty {
                                    Button("Add Task") {
                                        showAddTaskDialog = true
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                        } else {
                            ForEach(taskViewModel.filteredTodayTasks) { task in
                                TaskRow(task: task, showDate: false)
                            }
                            .onDelete(perform: deleteItems)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddTaskDialog = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTaskDialog) {
                AddTaskDialogView(showMe: $showAddTaskDialog)
            }
        }
    }
    
    private var searchTextBinding: Binding<String> {
        Binding(
            get: { taskViewModel.todaySearchText },
            set: { taskViewModel.updateTodaySearch($0) }
        )
    }
    
    private var emptyMessage: String {
        if taskViewModel.todaySearchText.isEmpty {
            return "No tasks for today.\nTap the + button to add one!"
        } else {
            return "No tasks found for '\(taskViewModel.todaySearchText)'"
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation(MasonAnimations.smooth) {
            taskViewModel.deleteTasks(at: offsets, from: .today)
        }
    }
}
