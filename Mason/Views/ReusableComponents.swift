//
//  ReusableComponents.swift
//  Mason
//
//  Created by AI Assistant on 12/26/24.
//

import SwiftUI

// MARK: - Reusable Task List View
struct TaskListView: View {
    let tasks: [Task]
    let emptyMessage: String
    let searchText: String
    let backgroundColor: Color
    let showDate: Bool
    let onDelete: ((IndexSet) -> Void)?
    let contextMenuProvider: ((Task) -> AnyView)?
    
    init(
        tasks: [Task],
        emptyMessage: String,
        searchText: String = "",
        backgroundColor: Color,
        showDate: Bool = false,
        onDelete: ((IndexSet) -> Void)? = nil,
        contextMenuProvider: ((Task) -> AnyView)? = nil
    ) {
        self.tasks = tasks
        self.emptyMessage = emptyMessage
        self.searchText = searchText
        self.backgroundColor = backgroundColor
        self.showDate = showDate
        self.onDelete = onDelete
        self.contextMenuProvider = contextMenuProvider
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                if !searchText.isEmpty && tasks.isEmpty {
                    EmptyStateView(
                        message: "No tasks found for '\(searchText)'",
                        icon: "magnifyingglass"
                    )
                } else if tasks.isEmpty {
                    EmptyStateView(
                        message: emptyMessage,
                        icon: "tray"
                    )
                } else {
                    List {
                        ForEach(tasks) { task in
                            Group {
                                if let contextMenuProvider = contextMenuProvider {
                                    TaskRow(task: task, showDate: showDate)
                                        .contextMenu {
                                            contextMenuProvider(task)
                                        }
                                } else {
                                    TaskRow(task: task, showDate: showDate)
                                }
                            }
                        }
                        .onDelete(perform: onDelete)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let message: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Standard Toolbar Configuration
struct StandardToolbarModifier: ViewModifier {
    let showAddButton: Bool
    let addAction: (() -> Void)?
    
    init(showAddButton: Bool = false, addAction: (() -> Void)? = nil) {
        self.showAddButton = showAddButton
        self.addAction = addAction
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    TopBarTitleWidget()
                }
                
                if showAddButton, let addAction = addAction {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: addAction) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
    }
}

extension View {
    func standardToolbar(showAddButton: Bool = false, addAction: (() -> Void)? = nil) -> some View {
        modifier(StandardToolbarModifier(showAddButton: showAddButton, addAction: addAction))
    }
}

// MARK: - Task View Container
struct TaskViewContainer<Content: View>: View {
    let title: String
    let backgroundColor: Color
    let searchPrompt: String
    let searchText: Binding<String>
    let showAddButton: Bool
    let addAction: (() -> Void)?
    let content: Content
    
    init(
        title: String,
        backgroundColor: Color,
        searchPrompt: String,
        searchText: Binding<String>,
        showAddButton: Bool = false,
        addAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.searchPrompt = searchPrompt
        self.searchText = searchText
        self.showAddButton = showAddButton
        self.addAction = addAction
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
                .standardToolbar(showAddButton: showAddButton, addAction: addAction)
                .navigationTitle(title)
                .searchable(text: searchText, prompt: searchPrompt)
        }
    }
}

// MARK: - Loading State View
struct LoadingStateView: View {
    let message: String
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Error State View
struct ErrorStateView: View {
    let message: String
    let retryAction: (() -> Void)?
    
    init(message: String, retryAction: (() -> Void)? = nil) {
        self.message = message
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let retryAction = retryAction {
                Button("Try Again", action: retryAction)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

// MARK: - Confirmation Dialog Helper
struct ConfirmationDialogHelper {
    static func deleteConfirmation(
        itemCount: Int,
        onConfirm: @escaping () -> Void
    ) -> some View {
        Group {
            Text("Are you sure you want to delete \(itemCount) task\(itemCount == 1 ? "" : "s")?")
            Button("Delete", role: .destructive, action: onConfirm)
            Button("Cancel", role: .cancel) { }
        }
    }
}

// MARK: - Task Context Menu Provider
struct TaskContextMenuProvider {
    static func previousTaskMenu(
        task: Task,
        onMoveToToday: @escaping (Task) -> Void
    ) -> AnyView {
        AnyView(
            Button {
                onMoveToToday(task)
            } label: {
                Label("Move to today", systemImage: "sunrise")
            }
        )
    }
    
    static func standardTaskMenu(
        task: Task,
        onEdit: @escaping (Task) -> Void,
        onDelete: @escaping (Task) -> Void
    ) -> AnyView {
        AnyView(
            Group {
                Button {
                    onEdit(task)
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(role: .destructive) {
                    onDelete(task)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        )
    }
}

// MARK: - Summary Card Component
struct SummaryCard: View {
    let title: String
    let count: Int
    let emptyMessage: String
    let backgroundColor: Color
    let action: () -> Void
    
    var subtitle: String {
        count == 0 ? emptyMessage : "\(count)"
    }
    
    var body: some View {
        Button(action: action) {
            SummaryTile(
                title: title,
                subtitle: subtitle,
                bgColor: backgroundColor
            )
            .padding()
        }
    }
}
