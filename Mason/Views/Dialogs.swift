//
//  Forms.swift
//  Mason
//
//  Created by Alexius Academia on 10/20/23.
//

import SwiftUI

struct AddTaskDialogView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var date: Date = .now
    @State private var taskName = "Sample Task"
    
    @State private var showAlert = false
    
    @Binding var showMe: Bool
    
    var body: some View {
        Form {
            DatePicker("Date",
                       selection: $date,
                       displayedComponents: [.date])
            
            TextField("Task Name", text: $taskName)
            
            Button {
                withAnimation {
                    let newTask = Task(timestamp: date, taskName: taskName)
                    modelContext.insert(newTask)
                    
                    showAlert = true
                }
            }label: {
                Text("Add Task")
            }
        }
        .alert("Task saved successfully!", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                showMe = false
            }
        }
    }
}
