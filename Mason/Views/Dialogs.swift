//
//  Forms.swift
//  Mason
//
//  Created by Alexius Academia on 10/20/23.
//

import SwiftUI

// MARK: - Edit Task Dialog
struct EditTaskDialogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var hapticManager: HapticManager
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @Bindable var task: Task
    @State private var editedTaskName: String = ""
    @State private var editedDate: Date = .now
    @State private var showAlert = false
    @State private var isLoading = false
    
    @Binding var showMe: Bool
    
    private var backgroundColorForSaveButton: Color {
        editedTaskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
        Color.gray.opacity(0.3) : Color.green
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Edit Task")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("Update your task details")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Form Content
                VStack(spacing: 20) {
                    // Task Name Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Task Name")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter task name...", text: $editedTaskName)
                            .textFieldStyle(.roundedBorder)
                            .submitLabel(.done)
                            .onSubmit {
                                saveChanges()
                            }
                            .accessibilityLabel("Task name input field")
                            .accessibilityHint("Edit the name of your task")
                    }
                    
                    // Date Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Due Date")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        DatePicker("Select date", selection: $editedDate, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                            .accessibilityLabel("Task due date")
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: saveChanges) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            }
                            Text(isLoading ? "Saving..." : "Save Changes")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(backgroundColorForSaveButton)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    }
                    .disabled(editedTaskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                    .accessibilityLabel("Save task changes")
                    .accessibilityHint("Tap to save the updated task")
                    
                    Button("Cancel") {
                        hapticManager.buttonPressed()
                        showMe = false
                    }
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Cancel task editing")
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        .alert("Success!", isPresented: $showAlert) {
            Button("OK") {
                showMe = false
            }
        } message: {
            Text("Task updated successfully!")
        }
        .onAppear {
            // Initialize with current task values
            editedTaskName = task.taskName
            editedDate = task.timestamp
        }
    }
    
    private func saveChanges() {
        let trimmedName = editedTaskName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, !isLoading else { return }
        
        isLoading = true
        hapticManager.buttonPressed()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            task.taskName = trimmedName
            task.timestamp = editedDate
            
            // IMPORTANT: Save the context to persist the changes
            do {
                try modelContext.save()
                
                // CRITICAL: Refresh the TaskViewModel to update UI
                taskViewModel.refreshAllTasks()
                
                // Add haptic feedback for success
                hapticManager.taskUpdated()
                
                // Announce for accessibility
                // AccessibilityManager.announce("Task updated: \(trimmedName)")
                
                isLoading = false
                showAlert = true
            } catch {
                print("Failed to save task changes: \(error)")
                isLoading = false
                // Could add error handling here
            }
        }
    }
}

// MARK: - Add Task Dialog
struct AddTaskDialogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var hapticManager: HapticManager
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @State private var date: Date = .now
    @State private var taskName = ""
    @State private var showAlert = false
    @State private var isLoading = false
    
    @Binding var showMe: Bool
    
    private var backgroundColorForAddButton: Color {
        taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
        Color.gray.opacity(0.3) : Color.blue
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Add New Task")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                    Text("Create a new task to stay organized")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Form Content
                VStack(spacing: 20) {
                    // Task Name Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Task Name")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your task...", text: $taskName)
                            .textFieldStyle(.roundedBorder)
                            .submitLabel(.done)
                            .onSubmit {
                                addTask()
                            }
                            .accessibilityLabel("Task name input field")
                            .accessibilityHint("Enter the name of your new task")
                    }
                    
                    // Date Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Due Date")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        DatePicker("Select date", selection: $date, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                            .accessibilityLabel("Task due date")
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: addTask) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            }
                            Text(isLoading ? "Adding..." : "Add Task")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(backgroundColorForAddButton)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    }
                    .disabled(taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                    .accessibilityLabel("Add new task")
                    .accessibilityHint("Tap to create the new task")
                    
                    Button("Cancel") {
                        hapticManager.buttonPressed()
                        showMe = false
                    }
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Cancel task creation")
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        .alert("Success!", isPresented: $showAlert) {
            Button("OK") {
                showMe = false
            }
        } message: {
            Text("Task added successfully!")
        }
        .onAppear {
            // Focus the text field when the view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // This delay helps with keyboard presentation
            }
        }
    }
    
    private func addTask() {
        let trimmedName = taskName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, !isLoading else { return }
        
        isLoading = true
        hapticManager.buttonPressed()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            let newTask = Task(timestamp: date, taskName: trimmedName)
            modelContext.insert(newTask)
            
            // IMPORTANT: Save the context to persist the data
            do {
                try modelContext.save()
                
                // CRITICAL: Refresh the TaskViewModel to update UI
                taskViewModel.refreshAllTasks()
                
                // Add haptic feedback for success
                hapticManager.taskAdded()
                
                // Announce for accessibility
                // AccessibilityManager.announceTaskAdded(trimmedName)
                
                isLoading = false
                showAlert = true
            } catch {
                print("Failed to save task: \(error)")
                isLoading = false
                // Could add error handling here
            }
        }
    }
}
