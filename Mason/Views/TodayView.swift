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
    @EnvironmentObject private var accessibilityManager: AccessibilityManager
    @EnvironmentObject private var hapticManager: HapticManager
    @State private var showAddTaskDialog = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                    
                    TextField("Search today's tasks...", text: searchTextBinding)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibleSearchBar(searchText: searchTextBinding)
                        .onChange(of: taskViewModel.todaySearchText) { oldValue, newValue in
                            if !newValue.isEmpty && oldValue.isEmpty {
                                hapticManager.searchResultsFound()
                            } else if newValue.isEmpty && !oldValue.isEmpty {
                                hapticManager.searchCleared()
                                if accessibilityManager.isVoiceOverEnabled {
                                    AccessibilityUtils.announce("Search cleared")
                                }
                            }
                            
                            // Announce search results
                            if !newValue.isEmpty {
                                let resultCount = taskViewModel.filteredTodayTasks.count
                                AccessibilityUtils.announceSearchResults(count: resultCount, searchTerm: newValue)
                                
                                if resultCount == 0 {
                                    hapticManager.searchNoResults()
                                }
                            }
                        }
                }
                .padding(.horizontal)
                
                // Task list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if taskViewModel.filteredTodayTasks.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: taskViewModel.todaySearchText.isEmpty ? "sun.max" : "magnifyingglass")
                                    .font(.system(size: 48))
                                    .foregroundColor(.orange)
                                    .accessibilityHidden(true)
                                
                                Text(emptyMessage)
                                    .font(accessibilityManager.isBoldTextEnabled ? .title3.bold() : .title3)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .dynamicTypeSize()
                                    .accessibilityAddTraits(.isStaticText)
                                
                                if taskViewModel.todaySearchText.isEmpty {
                                    Button("Add Task") {
                                        showAddTaskDialog = true
                                        hapticManager.buttonPressed()
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .accessibleAddButton {
                                        showAddTaskDialog = true
                                        hapticManager.buttonPressed()
                                    }
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
                .accessibilityLabel("Today's tasks")
                .accessibilityHint(taskViewModel.filteredTodayTasks.isEmpty ? 
                                 "No tasks for today" : 
                                 "\(taskViewModel.filteredTodayTasks.count) tasks for today")
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddTaskDialog = true
                        hapticManager.buttonPressed()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .frame(minWidth: AccessibilityConstants.minimumTouchTargetSize,
                                   minHeight: AccessibilityConstants.minimumTouchTargetSize)
                    }
                    .accessibleAddButton {
                        showAddTaskDialog = true
                        hapticManager.buttonPressed()
                    }
                }
            }
            .sheet(isPresented: $showAddTaskDialog) {
                AddTaskDialogView(showMe: $showAddTaskDialog)
                    .onAppear {
                        hapticManager.modalPresented()
                    }
                    .onDisappear {
                        hapticManager.modalDismissed()
                    }
            }
            .onAppear {
                if accessibilityManager.isVoiceOverEnabled {
                    AccessibilityUtils.announceScreenChange()
                }
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
