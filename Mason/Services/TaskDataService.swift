//
//  TaskDataService.swift
//  Mason
//
//  Created by AI Assistant on 12/26/24.
//

import SwiftUI
import SwiftData
import Foundation

// MARK: - Task Data Service Protocol
protocol TaskDataServiceProtocol {
    func fetchAllTasks() async throws -> [Task]
    func addTask(name: String, date: Date) async throws -> Task
    func updateTask(_ task: Task, name: String, date: Date) async throws
    func toggleTaskCompletion(_ task: Task) async throws
    func deleteTask(_ task: Task) async throws
    func deleteTasks(_ tasks: [Task]) async throws
}

// MARK: - SwiftData Implementation
@MainActor
class SwiftDataTaskService: TaskDataServiceProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchAllTasks() async throws -> [Task] {
        let descriptor = FetchDescriptor<Task>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func addTask(name: String, date: Date) async throws -> Task {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw TaskDataError.invalidTaskName
        }
        
        let newTask = Task(timestamp: date, taskName: trimmedName)
        modelContext.insert(newTask)
        try modelContext.save()
        return newTask
    }
    
    func updateTask(_ task: Task, name: String, date: Date) async throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw TaskDataError.invalidTaskName
        }
        
        task.taskName = trimmedName
        task.timestamp = date
        try modelContext.save()
    }
    
    func toggleTaskCompletion(_ task: Task) async throws {
        task.completed.toggle()
        try modelContext.save()
    }
    
    func deleteTask(_ task: Task) async throws {
        modelContext.delete(task)
        try modelContext.save()
    }
    
    func deleteTasks(_ tasks: [Task]) async throws {
        for task in tasks {
            modelContext.delete(task)
        }
        try modelContext.save()
    }
}

// MARK: - Error Types
enum TaskDataError: LocalizedError {
    case invalidTaskName
    case taskNotFound
    case saveFailure
    case fetchFailure
    
    var errorDescription: String? {
        switch self {
        case .invalidTaskName:
            return "Task name cannot be empty"
        case .taskNotFound:
            return "Task not found"
        case .saveFailure:
            return "Failed to save task"
        case .fetchFailure:
            return "Failed to fetch tasks"
        }
    }
}

// MARK: - Task Filtering Service
@MainActor
class TaskFilterService: ObservableObject {
    
    static func filterTodayTasks(from tasks: [Task]) -> [Task] {
        let calendar = Calendar.current
        return tasks
            .filter { calendar.isDateInToday($0.timestamp) }
            .sorted { !$0.completed && $1.completed }
    }
    
    static func filterWeeklyTasks(from tasks: [Task]) -> [Task] {
        let calendar = Calendar.current
        let now = Date.now
        let currentWeek = calendar.component(.weekOfYear, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        return tasks.filter { task in
            let taskWeek = calendar.component(.weekOfYear, from: task.timestamp)
            let taskYear = calendar.component(.year, from: task.timestamp)
            return taskWeek == currentWeek && taskYear == currentYear
        }
    }
    
    static func filterPreviousIncompleteTasks(from tasks: [Task]) -> [Task] {
        let calendar = Calendar.current
        let now = Date.now
        
        return tasks.filter { task in
            !calendar.isDateInToday(task.timestamp) &&
            task.timestamp < now &&
            !task.completed
        }
    }
    
    static func filterTasks(_ tasks: [Task], with searchText: String) -> [Task] {
        guard !searchText.isEmpty else { return tasks }
        return tasks.filter { task in
            task.taskName.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Task Statistics Service
@MainActor
class TaskStatisticsService: ObservableObject {
    
    static func generateSummary(from tasks: [Task]) -> TaskSummary {
        let todayTasks = TaskFilterService.filterTodayTasks(from: tasks)
        let weeklyTasks = TaskFilterService.filterWeeklyTasks(from: tasks)
        let previousTasks = TaskFilterService.filterPreviousIncompleteTasks(from: tasks)
        
        return TaskSummary(
            todayCount: todayTasks.count,
            todayCompleted: todayTasks.filter(\.completed).count,
            weeklyCount: weeklyTasks.count,
            weeklyCompleted: weeklyTasks.filter(\.completed).count,
            previousIncompleteCount: previousTasks.count,
            totalCount: tasks.count,
            totalCompleted: tasks.filter(\.completed).count
        )
    }
}

// MARK: - Supporting Models
struct TaskSummary {
    let todayCount: Int
    let todayCompleted: Int
    let weeklyCount: Int
    let weeklyCompleted: Int
    let previousIncompleteCount: Int
    let totalCount: Int
    let totalCompleted: Int
    
    var todayDisplayText: String {
        todayCount == 0 ? "No tasks for today." : "\(todayCount)"
    }
    
    var weeklyDisplayText: String {
        weeklyCount == 0 ? "No tasks for this week" : "\(weeklyCount)"
    }
    
    var previousDisplayText: String {
        previousIncompleteCount == 0 ? "No pending previous tasks." : "\(previousIncompleteCount)"
    }
    
    var completionRate: Double {
        guard totalCount > 0 else { return 0.0 }
        return Double(totalCompleted) / Double(totalCount)
    }
}
