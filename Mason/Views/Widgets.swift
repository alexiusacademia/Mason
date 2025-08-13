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
    @EnvironmentObject private var accessibilityManager: AccessibilityManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with icon and title
            HStack {
                // Icon based on title
                Image(systemName: iconForTitle(title))
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.white.opacity(0.2))
                    )
                
                Spacer()
                
                // Count display
                if let count = Int(subtitle), count > 0 {
                    Text("\(count)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.2))
                        )
                }
            }
            
            // Title and description
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                
                HStack {
                    if let count = Int(subtitle), count > 0 {
                        Text(count == 1 ? "1 task" : "\(count) tasks")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    } else {
                        Text(subtitle)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding(20)
        .frame(minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [bgColor, bgColor.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: bgColor.opacity(0.3), radius: 8, x: 0, y: 4)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title) section")
        .accessibilityValue(subtitle)
        .accessibilityAddTraits(.isButton)
    }
    
    private func iconForTitle(_ title: String) -> String {
        switch title.lowercased() {
        case "today":
            return "sun.max.fill"
        case "previous":
            return "clock.fill"
        case "weekly":
            return "calendar.badge.clock"
        default:
            return "list.bullet"
        }
    }
}

struct TaskRow: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: Task
    let showDate: Bool
    @State private var date = ""
    @State private var showEditDialog = false
    @EnvironmentObject private var hapticManager: HapticManager
    @EnvironmentObject private var accessibilityManager: AccessibilityManager
    @EnvironmentObject private var taskViewModel: TaskViewModel
    
    init(task: Task, showDate: Bool = false) {
        self.task = task
        self.showDate = showDate
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    let wasCompleted = task.completed
                    task.completed = !task.completed
                    
                    // Haptic feedback
                    if task.completed {
                        hapticManager.taskCompleted()
                        AccessibilityUtils.announceTaskCompleted(task.taskName)
                    } else {
                        hapticManager.taskUncompleted()
                    }
                    
                } label: {
                    Image(systemName: task.completed ? "checkmark.square.fill" : "square")
                        .foregroundColor(task.completed ? .green : .primary)
                        .font(.title3)
                        .frame(minWidth: AccessibilityConstants.minimumTouchTargetSize, 
                               minHeight: AccessibilityConstants.minimumTouchTargetSize)
                }
                .accessibilityLabel(task.completed ? "Completed" : "Not completed")
                .accessibilityHint(AccessibilityLabels.taskToggleHint(isCompleted: task.completed))
                .accessibilityIdentifier(AccessibilityConstants.Identifiers.toggleButton)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.taskName)
                        .font(accessibilityManager.isBoldTextEnabled ? .body.bold() : .body)
                        .foregroundStyle(task.completed ? .secondary : .primary)
                        .strikethrough(task.completed)
                        .dynamicTypeSize()
                        .lineLimit(accessibilityManager.isVoiceOverEnabled ? 0 : 2)
                    
                    if showDate {
                        Text(date)
                            .font(accessibilityManager.isBoldTextEnabled ? .caption.bold() : .caption)
                            .foregroundStyle(.secondary)
                            .dynamicTypeSize()
                    }
                }
                
                Spacer()
                
                // Edit button
                Button {
                    showEditDialog = true
                    hapticManager.buttonPressed()
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .font(.title3)
                        .frame(minWidth: AccessibilityConstants.minimumTouchTargetSize,
                               minHeight: AccessibilityConstants.minimumTouchTargetSize)
                }
                .accessibilityLabel("Edit task")
                .accessibilityHint(AccessibilityLabels.taskEditHint())
                .accessibilityIdentifier(AccessibilityConstants.Identifiers.editButton)
                .buttonStyle(PlainButtonStyle())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibleTaskRow(
            taskName: task.taskName,
            isCompleted: task.completed,
            date: showDate ? date : nil,
            onToggle: {
                let wasCompleted = task.completed
                task.completed = !task.completed
                
                // Save the change to the database
                do {
                    try modelContext.save()
                    // Refresh the ViewModel to update UI
                    taskViewModel.refreshAllTasks()
                } catch {
                    // Revert if save failed
                    task.completed = wasCompleted
                    print("Failed to save task completion: \(error)")
                }
                
                if task.completed {
                    hapticManager.taskCompleted()
                    AccessibilityUtils.announceTaskCompleted(task.taskName)
                } else {
                    hapticManager.taskUncompleted()
                }
            },
            onEdit: {
                showEditDialog = true
                hapticManager.buttonPressed()
            }
        )
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(accessibilityManager.isHighContrastEnabled ? 
                      Color.accessibleCardBackground(isHighContrast: true) :
                      Color.clear)
                .stroke(accessibilityManager.isHighContrastEnabled ? Color.primary : Color.clear, lineWidth: 1)
        )
        .onAppear() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            date = dateFormatter.string(from: task.timestamp)
        }
        .sheet(isPresented: $showEditDialog) {
            EditTaskDialogView(task: task, showMe: $showEditDialog)
                .onDisappear {
                    hapticManager.modalDismissed()
                }
        }
        .accessibilityIdentifier(AccessibilityConstants.Identifiers.taskRow)
    }
}
