//
//  MainView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Binding var selectedTab: Tag
    @Query private var tasks: [Task]
    
    @State private var showAddTaskDialog = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Button {
                        selectedTab = Tag.today
                    }label: {
                        SummaryTile(title: "Today", subtitle: "10", bgColor: Color.orange.opacity(0.5))
                            .padding()
                    }
                    
                    Button {
                        selectedTab = Tag.previous
                    }label: {
                        SummaryTile(title: "Previous", subtitle: "14", bgColor: Color.blue.opacity(0.5))
                            .padding()
                    }
                    
                    Button {
                        selectedTab = Tag.weekly
                    }label: {
                        SummaryTile(title: "Weekly", subtitle: "35", bgColor: Color.green.opacity(0.5))
                            .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    TopBarTitleWidget()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddTaskDialog = true
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }.sheet(isPresented: $showAddTaskDialog, content: {
                AddTaskDialogView(showMe: $showAddTaskDialog)
            })
        }.onAppear() {
            for task in tasks {
                print("\(task.taskName) on \(task.timestamp)")
            }
        }
    }
}
