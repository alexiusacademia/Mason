//
//  ModernMainView.swift
//  Mason
//
//  Created by AI Assistant on 12/26/24.
//  Modern redesigned main view with animations
//

import SwiftUI
import SwiftData

struct ModernMainView: View {
    @Binding var selectedTab: Tag
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @State private var showAddTaskDialog = false
    @State private var appeared = false

    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: MasonSpacing.lg) {
                    // Welcome header
                    VStack(alignment: .leading, spacing: MasonSpacing.md) {
                        Text("Good \(timeOfDay)!")
                            .font(MasonTypography.largeTitle)
                            .foregroundColor(MasonColors.label)
                            .opacity(appeared ? 1.0 : 0.0)
                            .offset(y: appeared ? 0 : 20)
                        
                        Text("Here's your task overview")
                            .font(MasonTypography.body)
                            .foregroundColor(MasonColors.secondaryLabel)
                            .opacity(appeared ? 1.0 : 0.0)
                            .offset(y: appeared ? 0 : 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, MasonSpacing.lg)
                    .animation(MasonAnimations.gentle.delay(0.1), value: appeared)
                    
                    // Task summary cards
                    VStack(spacing: MasonSpacing.md) {
                        ModernSummaryCard(
                            title: "Today",
                            count: taskViewModel.todayTasks.count,
                            emptyMessage: "No tasks for today",
                            gradient: MasonColors.todayGradient
                        ) {
                            withAnimation(MasonAnimations.smooth) {
                                selectedTab = Tag.today
                            }
                        }
                        .opacity(appeared ? 1.0 : 0.0)
                        .offset(x: appeared ? 0 : -50)
                        .animation(MasonAnimations.gentle.delay(0.2), value: appeared)
                        
                        ModernSummaryCard(
                            title: "Previous",
                            count: taskViewModel.previousIncompleteTasks.count,
                            emptyMessage: "No pending tasks",
                            gradient: MasonColors.previousGradient
                        ) {
                            withAnimation(MasonAnimations.smooth) {
                                selectedTab = Tag.previous
                            }
                        }
                        .opacity(appeared ? 1.0 : 0.0)
                        .offset(x: appeared ? 0 : 50)
                        .animation(MasonAnimations.gentle.delay(0.3), value: appeared)
                        
                        ModernSummaryCard(
                            title: "Weekly",
                            count: taskViewModel.weeklyTasks.count,
                            emptyMessage: "No weekly tasks",
                            gradient: MasonColors.weeklyGradient
                        ) {
                            withAnimation(MasonAnimations.smooth) {
                                selectedTab = Tag.weekly
                            }
                        }
                        .opacity(appeared ? 1.0 : 0.0)
                        .offset(x: appeared ? 0 : -50)
                        .animation(MasonAnimations.gentle.delay(0.4), value: appeared)
                    }
                    .padding(.horizontal, MasonSpacing.lg)
                    
                    // Quick stats
                    if totalTaskCount > 0 {
                        VStack(spacing: MasonSpacing.md) {
                            HStack {
                                Text("Quick Stats")
                                    .font(MasonTypography.title3)
                                    .foregroundColor(MasonColors.label)
                                
                                Spacer()
                            }
                            
                            HStack(spacing: MasonSpacing.lg) {
                                StatCard(
                                    title: "Total",
                                    value: "\(totalTaskCount)",
                                    icon: "list.bullet"
                                )
                                
                                StatCard(
                                    title: "Completed",
                                    value: "\(completedTaskCount)",
                                    icon: "checkmark.circle.fill"
                                )
                                
                                StatCard(
                                    title: "Progress",
                                    value: "\(progressPercentage)%",
                                    icon: "chart.line.uptrend.xyaxis"
                                )
                            }
                        }
                        .padding(.horizontal, MasonSpacing.lg)
                        .opacity(appeared ? 1.0 : 0.0)
                        .offset(y: appeared ? 0 : 30)
                        .animation(MasonAnimations.gentle.delay(0.5), value: appeared)
                    }
                }
                .padding(.vertical, MasonSpacing.lg)
            }
            .background(MasonColors.background)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ModernNavigationHeader(
                        title: "Mason",
                        showAddButton: false,
                        addAction: nil
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddTaskDialog = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .floatingActionButton()
                    .pressableButton()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddTaskDialog) {
                ModernAddTaskDialog(showMe: $showAddTaskDialog)
            }
        }
        .onAppear {
            withAnimation(MasonAnimations.gentle) {
                appeared = true
            }
        }
    }
    
    private var timeOfDay: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Morning"
        case 12..<17: return "Afternoon"
        case 17..<22: return "Evening"
        default: return "Night"
        }
    }
    
    private var totalTaskCount: Int {
        taskViewModel.allTasks.count
    }
    
    private var completedTaskCount: Int {
        taskViewModel.allTasks.filter { $0.completed }.count
    }
    
    private var progressPercentage: Int {
        guard totalTaskCount > 0 else { return 0 }
        return Int((Double(completedTaskCount) / Double(totalTaskCount)) * 100)
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: MasonSpacing.xs) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(MasonColors.primary)
                .scaleEffect(appeared ? 1.0 : 0.1)
            
            Text(value)
                .font(MasonTypography.title3)
                .fontWeight(.bold)
                .foregroundColor(MasonColors.label)
                .contentTransition(.numericText())
            
            Text(title)
                .font(MasonTypography.caption)
                .foregroundColor(MasonColors.secondaryLabel)
        }
        .padding(MasonSpacing.md)
        .frame(maxWidth: .infinity)
        .background(MasonColors.tertiaryBackground)
        .cornerRadius(MasonRadius.md)
        .animation(MasonAnimations.bouncy.delay(0.1), value: appeared)
        .onAppear {
            withAnimation(MasonAnimations.gentle.delay(Double.random(in: 0...0.3))) {
                appeared = true
            }
        }
    }
}

// MARK: - Modern Add Task Dialog
struct ModernAddTaskDialog: View {
    @Environment(\.modelContext) private var modelContext
    @State private var taskName = ""
    @State private var selectedDate = Date.now
    @State private var showAlert = false
    
    @Binding var showMe: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: MasonSpacing.xl) {
                // Header
                VStack(spacing: MasonSpacing.md) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(MasonColors.primary)
                    
                    Text("Add New Task")
                        .font(MasonTypography.title1)
                        .foregroundColor(MasonColors.label)
                }
                .padding(.top, MasonSpacing.xl)
                
                // Form
                VStack(spacing: MasonSpacing.lg) {
                    VStack(alignment: .leading, spacing: MasonSpacing.sm) {
                        Text("Task Name")
                            .font(MasonTypography.bodyMedium)
                            .foregroundColor(MasonColors.label)
                        
                        TextField("Enter task name...", text: $taskName)
                            .font(MasonTypography.body)
                            .padding(MasonSpacing.md)
                            .background(MasonColors.tertiaryBackground)
                            .cornerRadius(MasonRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: MasonRadius.md)
                                    .stroke(MasonColors.primary.opacity(taskName.isEmpty ? 0 : 0.5), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: MasonSpacing.sm) {
                        Text("Date")
                            .font(MasonTypography.bodyMedium)
                            .foregroundColor(MasonColors.label)
                        
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                            .padding(MasonSpacing.md)
                            .background(MasonColors.tertiaryBackground)
                            .cornerRadius(MasonRadius.md)
                    }
                }
                .padding(.horizontal, MasonSpacing.lg)
                
                Spacer()
                
                // Buttons
                HStack(spacing: MasonSpacing.md) {
                    Button("Cancel") {
                        withAnimation(MasonAnimations.smooth) {
                            showMe = false
                        }
                    }
                    .font(MasonTypography.button)
                    .foregroundColor(MasonColors.secondaryLabel)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, MasonSpacing.md)
                    .background(MasonColors.tertiaryBackground)
                    .cornerRadius(MasonRadius.md)
                    
                    Button("Add Task") {
                        if !taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            let newTask = Task(timestamp: selectedDate, taskName: taskName.trimmingCharacters(in: .whitespacesAndNewlines))
                            modelContext.insert(newTask)
                            
                            // Success haptic
                            let successFeedback = UINotificationFeedbackGenerator()
                            successFeedback.notificationOccurred(.success)
                            
                            withAnimation(MasonAnimations.smooth) {
                                showMe = false
                            }
                        } else {
                            showAlert = true
                        }
                    }
                    .font(MasonTypography.button)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, MasonSpacing.md)
                    .background(
                        taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
                        ? MasonColors.secondaryLabel 
                        : MasonColors.primary
                    )
                    .cornerRadius(MasonRadius.md)
                    .disabled(taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, MasonSpacing.lg)
                .padding(.bottom, MasonSpacing.xl)
            }
            .background(MasonColors.background)
            .navigationBarHidden(true)
        }
        .alert("Empty Task Name", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter a task name before adding.")
        }
    }
}
