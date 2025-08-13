//
//  PreviousDaysView.swift
//  Mason
//
//  Created by Alexius Academia on 10/19/23.
//

import SwiftUI
import SwiftData

struct PreviousDaysView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        TaskViewContainer(
            title: "Previous",
            backgroundColor: Color.blue.opacity(0.3),
            searchPrompt: "Search previous tasks...",
            searchText: Binding(
                get: { taskViewModel.previousSearchText },
                set: { taskViewModel.updatePreviousSearch($0) }
            )
        ) {
            TaskListView(
                tasks: taskViewModel.filteredPreviousTasks,
                emptyMessage: "No previous pending tasks.",
                searchText: taskViewModel.previousSearchText,
                backgroundColor: Color.blue.opacity(0.3),
                showDate: true,
                onDelete: deleteItems,
                contextMenuProvider: { task in
                    TaskContextMenuProvider.previousTaskMenu(task: task) { task in
                        taskViewModel.moveTaskToToday(task)
                    }
                }
            )
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            taskViewModel.deleteTasks(at: offsets, from: .previous)
        }
    }
}
