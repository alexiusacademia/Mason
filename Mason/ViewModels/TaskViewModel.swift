//
//  TaskViewModel.swift
//  Mason
//
//  Created by AI Assistant on 12/26/24.
//

import SwiftUI
import SwiftData
import Foundation

@MainActor
@Observable
class TaskViewModel: ObservableObject {
    private var modelContext: ModelContext?
    
    // MARK: - Published Properties
    var todayTasks: [Task] = []
    var weeklyTasks: [Task] = []
    var previousIncompleteTasks: [Task] = []
    var allTasks: [Task] = []
    
    // Search states
    var todaySearchText: String = ""
    var weeklySearchText: String = ""
    var previousSearchText: String = ""
    
    // Loading states
    var isLoading: Bool = false
    var errorMessage: String?
    
    // MARK: - Computed Properties
    var todayTaskCount: String {
        let count = todayTasks.count
        return count == 0 ? "No tasks for today." : "\(count)"
    }
    
    var previousIncompleteTaskCount: String {
        let count = previousIncompleteTasks.count
        return count == 0 ? "No pending previous tasks." : "\(count)"
    }
    
    var weeklyTaskCount: String {
        let count = weeklyTasks.count
        return count == 0 ? "No tasks for this week" : "\(count)"
    }
    
    // Filtered tasks based on search
    var filteredTodayTasks: [Task] {
        if todaySearchText.isEmpty {
            return todayTasks.sorted { !$0.completed && $1.completed }
        }
        return todayTasks
            .filter { $0.taskName.localizedCaseInsensitiveContains(todaySearchText) }
            .sorted { !$0.completed && $1.completed }
    }
    
    var filteredWeeklyTasks: [Task] {
        if weeklySearchText.isEmpty {
            return weeklyTasks
        }
        return weeklyTasks
            .filter { $0.taskName.localizedCaseInsensitiveContains(weeklySearchText) }
    }
    
    var filteredPreviousTasks: [Task] {
        if previousSearchText.isEmpty {
            return previousIncompleteTasks
        }
        return previousIncompleteTasks
            .filter { $0.taskName.localizedCaseInsensitiveContains(previousSearchText) }
    }
    
    // MARK: - Initialization
    func configure(with modelContext: ModelContext) {
        self.modelContext = modelContext
        refreshAllTasks()
    }
    
    // MARK: - Data Management
    func refreshAllTasks() {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<Task>(
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
            )
            allTasks = try modelContext.fetch(descriptor)
            updateFilteredTasks()
        } catch {
            handleError(error)
        }
    }
    
    private func updateFilteredTasks() {
        let calendar = Calendar.current
        let now = Date.now
        
        todayTasks = allTasks.filter { calendar.isDateInToday($0.timestamp) }
        
        let currentWeek = calendar.component(.weekOfYear, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        weeklyTasks = allTasks.filter { task in
            let taskWeek = calendar.component(.weekOfYear, from: task.timestamp)
            let taskYear = calendar.component(.year, from: task.timestamp)
            return taskWeek == currentWeek && taskYear == currentYear
        }
        
        previousIncompleteTasks = allTasks.filter { task in
            !calendar.isDateInToday(task.timestamp) &&
            task.timestamp < now &&
            !task.completed
        }
    }
    
    // MARK: - Task Operations
    func addTask(name: String, date: Date = .now) {
        guard let modelContext = modelContext else { return }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        do {
            let newTask = Task(timestamp: date, taskName: trimmedName)
            modelContext.insert(newTask)
            try modelContext.save()
            refreshAllTasks()
        } catch {
            handleError(error)
        }
    }
    
    func updateTask(_ task: Task, name: String, date: Date) {
        guard let modelContext = modelContext else { return }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        do {
            task.taskName = trimmedName
            task.timestamp = date
            try modelContext.save()
            refreshAllTasks()
        } catch {
            handleError(error)
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        guard let modelContext = modelContext else { return }
        
        do {
            task.completed.toggle()
            try modelContext.save()
            refreshAllTasks()
        } catch {
            handleError(error)
        }
    }
    
    func deleteTask(_ task: Task) {
        guard let modelContext = modelContext else { return }
        
        do {
            modelContext.delete(task)
            try modelContext.save()
            refreshAllTasks()
        } catch {
            handleError(error)
        }
    }
    
    func deleteTasks(at offsets: IndexSet, from taskList: TaskList) {
        guard let modelContext = modelContext else { return }
        
        let tasksToDelete: [Task]
        switch taskList {
        case .today:
            tasksToDelete = offsets.map { filteredTodayTasks[$0] }
        case .weekly:
            tasksToDelete = offsets.map { filteredWeeklyTasks[$0] }
        case .previous:
            tasksToDelete = offsets.map { filteredPreviousTasks[$0] }
        }
        
        do {
            for task in tasksToDelete {
                modelContext.delete(task)
            }
            try modelContext.save()
            refreshAllTasks()
        } catch {
            handleError(error)
        }
    }
    
    func moveTaskToToday(_ task: Task) {
        guard let modelContext = modelContext else { return }
        
        do {
            task.timestamp = Date.now
            try modelContext.save()
            refreshAllTasks()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Search Management
    func updateTodaySearch(_ searchText: String) {
        todaySearchText = searchText
    }
    
    func updateWeeklySearch(_ searchText: String) {
        weeklySearchText = searchText
    }
    
    func updatePreviousSearch(_ searchText: String) {
        previousSearchText = searchText
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        print("TaskViewModel Error: \(error)")
    }
    
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Supporting Types
enum TaskList {
    case today
    case weekly
    case previous
}
