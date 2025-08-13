//
//  WeeklyView.swift
//  Mason
//
//  Created by Alexius Academia on 10/19/23.
//

import SwiftUI
import SwiftData

struct WeeklyView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        TaskViewContainer(
            title: "Weekly",
            backgroundColor: Color.green.opacity(0.3),
            searchPrompt: "Search weekly tasks...",
            searchText: Binding(
                get: { taskViewModel.weeklySearchText },
                set: { taskViewModel.updateWeeklySearch($0) }
            )
        ) {
            TaskListView(
                tasks: taskViewModel.filteredWeeklyTasks,
                emptyMessage: "No tasks for this week.",
                searchText: taskViewModel.weeklySearchText,
                backgroundColor: Color.green.opacity(0.3),
                showDate: true,
                onDelete: deleteItems
            )
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            taskViewModel.deleteTasks(at: offsets, from: .weekly)
        }
    }
}
