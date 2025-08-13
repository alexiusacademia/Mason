//
//  Widgets.swift
//  Mason
//
//  Created by Alexius Academia on 10/19/23.
//

import SwiftUI

struct TopBarTitleWidget: View {
    var body: some View {
        HStack {
            Image(.bee)
                .resizable()
                .scaledToFit()
            Text("Mason")
                .font(.title)
                .bold()
        }
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

struct SummaryTile: View {
    let title: String
    let subtitle: String
    let bgColor: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.light)
                .foregroundStyle(Color.normalText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Text(subtitle)
                .font(subtitle.isInt ? .largeTitle : .headline)
                .fontWeight(.black)
                .foregroundStyle(.normalText)
                .bold()
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(bgColor)
            
        )
    }
}

struct TaskRow: View {
    @Bindable var task: Task
    let showDate: Bool
    @State private var date = ""
    @State private var showEditDialog = false
    
    init(task: Task, showDate: Bool = false) {
        self.task = task
        self.showDate = showDate
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    task.completed = !task.completed
                    // SwiftData will automatically update all views using this task
                } label: {
                    Image(systemName: task.completed ? "checkmark.square" : "square")
                }
                
                Text(task.taskName)
                    .bold()
                    .foregroundStyle(task.completed ? .green.opacity(0.8) : .normalText)
                
                Spacer()
                
                // Edit button
                Button {
                    showEditDialog = true
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
                .buttonStyle(PlainButtonStyle())
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            if showDate {
                Text(date)
                    .font(.subheadline)
                    .foregroundStyle(.gray.opacity(0.75))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            date = dateFormatter.string(from: task.timestamp)
        }
        .sheet(isPresented: $showEditDialog) {
            EditTaskDialogView(task: task, showMe: $showEditDialog)
        }
    }
}
