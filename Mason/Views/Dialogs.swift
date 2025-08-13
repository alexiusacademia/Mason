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
    @Bindable var task: Task
    
    @State private var editedTaskName: String = ""
    @State private var editedDate: Date = .now
    @State private var showAlert = false
    
    @Binding var showMe: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Task")
                    .font(.title)
                    .padding()
                
                Form {
                    DatePicker("Date",
                               selection: $editedDate,
                               displayedComponents: [.date])
                    
                    TextField("Task Name", text: $editedTaskName)
                        .onSubmit {
                            saveChanges()
                        }
                    
                    Section {
                        Button {
                            saveChanges()
                        } label: {
                            Text("Save Changes")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(editedTaskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        
                        Button {
                            showMe = false
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .alert("Task updated successfully!", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {
                        showMe = false
                    }
                }
            }
            .onAppear {
                // Initialize with current task values
                editedTaskName = task.taskName
                editedDate = task.timestamp
            }
        }
    }
    
    private func saveChanges() {
        let trimmedName = editedTaskName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        withAnimation {
            task.taskName = trimmedName
            task.timestamp = editedDate
            showAlert = true
        }
    }
}

// MARK: - Add Task Dialog
struct AddTaskDialogView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var date: Date = .now
    @State private var taskName = ""
    
    @State private var showAlert = false
    
    @Binding var showMe: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add Task")
                    .font(.title)
                    .padding()
                
                Form {
                    DatePicker("Date",
                               selection: $date,
                               displayedComponents: [.date])
                    
                    TextField("Enter task name...", text: $taskName)
                        .onSubmit {
                            addTask()
                        }
                    
                    Section {
                        Button {
                            addTask()
                        } label: {
                            Text("Add Task")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        
                        Button {
                            showMe = false
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .alert("Task added successfully!", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {
                        showMe = false
                    }
                }
            }
        }
    }
    
    private func addTask() {
        let trimmedName = taskName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        withAnimation {
            let newTask = Task(timestamp: date, taskName: trimmedName)
            modelContext.insert(newTask)
            showAlert = true
        }
    }
}
