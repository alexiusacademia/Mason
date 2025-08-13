//
//  ModernComponents.swift
//  Mason
//
//  Created by AI Assistant on 12/26/24.
//  Modern UI Components with animations
//

import SwiftUI

// MARK: - Modern Summary Card
struct ModernSummaryCard: View {
    let title: String
    let count: Int
    let emptyMessage: String
    let gradient: LinearGradient
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var appeared = false
    
    var subtitle: String {
        count == 0 ? emptyMessage : "\(count)"
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: MasonSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: MasonSpacing.xs) {
                        Text(title)
                            .font(MasonTypography.title3)
                            .foregroundColor(MasonColors.label)
                        
                        if count > 0 {
                            Text("\(count)")
                                .font(MasonTypography.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(MasonColors.primary)
                                .contentTransition(.numericText())
                        } else {
                            Text(emptyMessage)
                                .font(MasonTypography.body)
                                .foregroundColor(MasonColors.secondaryLabel)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    Spacer()
                    
                    // Animated icon based on count
                    ZStack {
                        Circle()
                            .fill(gradient)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: iconName)
                            .font(.title2)
                            .foregroundColor(.white)
                            .scaleEffect(appeared ? 1.0 : 0.1)
                            .animation(MasonAnimations.bouncy.delay(0.3), value: appeared)
                    }
                }
            }
            .padding(MasonSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: MasonRadius.lg)
                    .fill(MasonColors.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: MasonRadius.lg)
                            .stroke(gradient, lineWidth: count > 0 ? 2 : 0)
                            .opacity(count > 0 ? 0.3 : 0)
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .shadow(
                color: MasonColors.primary.opacity(count > 0 ? 0.1 : 0.05),
                radius: count > 0 ? 12 : 8,
                x: 0,
                y: count > 0 ? 6 : 4
            )
            .animation(MasonAnimations.gentle, value: count)
            .animation(MasonAnimations.buttonPress, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .pressEvents { pressing in
            isPressed = pressing
        }
        .onAppear {
            withAnimation(MasonAnimations.gentle.delay(0.1)) {
                appeared = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) tasks")
        .accessibilityValue("\(count) tasks")
        .accessibilityHint("Double tap to view \(title.lowercased()) tasks")
    }
    
    private var iconName: String {
        switch title.lowercased() {
        case "today": return count > 0 ? "sun.max.fill" : "sun.max"
        case "previous": return count > 0 ? "clock.fill" : "clock"
        case "weekly": return count > 0 ? "calendar.circle.fill" : "calendar.circle"
        default: return "list.bullet"
        }
    }
}

// MARK: - Modern Task Row
struct ModernTaskRow: View {
    @Bindable var task: Task
    let showDate: Bool
    @State private var showEditDialog = false
    @State private var isCompleting = false
    @State private var appeared = false
    
    init(task: Task, showDate: Bool = false) {
        self.task = task
        self.showDate = showDate
    }
    
    var body: some View {
        HStack(spacing: MasonSpacing.md) {
            // Animated completion button
            Button {
                withAnimation(MasonAnimations.snappy) {
                    isCompleting = true
                }
                
                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    task.completed.toggle()
                    isCompleting = false
                }
            } label: {
                ZStack {
                    Circle()
                        .stroke(
                            task.completed ? MasonColors.success : MasonColors.tertiaryLabel,
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(task.completed ? MasonColors.success : Color.clear)
                                .scaleEffect(task.completed ? 1.0 : 0.1)
                        )
                    
                    if task.completed {
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white)
                            .scaleEffect(isCompleting ? 1.3 : 1.0)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .animation(MasonAnimations.bouncy, value: task.completed)
            .animation(MasonAnimations.snappy, value: isCompleting)
            
            VStack(alignment: .leading, spacing: MasonSpacing.xs) {
                Text(task.taskName)
                    .font(MasonTypography.body)
                    .fontWeight(task.completed ? .regular : .medium)
                    .foregroundColor(task.completed ? MasonColors.secondaryLabel : MasonColors.label)
                    .strikethrough(task.completed, color: MasonColors.secondaryLabel)
                    .animation(MasonAnimations.smooth, value: task.completed)
                
                if showDate {
                    Text(formattedDate)
                        .font(MasonTypography.caption)
                        .foregroundColor(MasonColors.tertiaryLabel)
                }
            }
            
            Spacer()
            
            // Edit button
            Button {
                showEditDialog = true
            } label: {
                Image(systemName: "pencil")
                    .font(.caption)
                    .foregroundColor(MasonColors.secondaryLabel)
                    .frame(width: 32, height: 32)
                    .background(MasonColors.tertiaryBackground)
                    .cornerRadius(8)
                    .opacity(appeared ? 1.0 : 0.0)
            }
            .buttonStyle(PlainButtonStyle())
            .animation(MasonAnimations.gentle.delay(0.2), value: appeared)
        }
        .padding(.vertical, MasonSpacing.sm)
        .padding(.horizontal, MasonSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: MasonRadius.md)
                .fill(MasonColors.background)
                .opacity(task.completed ? 0.6 : 1.0)
        )
        .overlay(
            RoundedRectangle(cornerRadius: MasonRadius.md)
                .stroke(MasonColors.tertiaryBackground, lineWidth: 1)
        )
        .scaleEffect(appeared ? 1.0 : 0.9)
        .opacity(appeared ? 1.0 : 0.0)
        .onAppear {
            withAnimation(MasonAnimations.gentle.delay(Double.random(in: 0...0.3))) {
                appeared = true
            }
        }
        .sheet(isPresented: $showEditDialog) {
            EditTaskDialogView(task: task, showMe: $showEditDialog)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(task.taskName)
        .accessibilityValue(task.completed ? "Completed" : "Incomplete")
        .accessibilityHint(task.completed ? "Double tap to mark as incomplete" : "Double tap to mark as complete")
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: task.timestamp)
    }
}

// MARK: - Modern Empty State
struct ModernEmptyState: View {
    let message: String
    let icon: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    @State private var appeared = false
    
    init(message: String, icon: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.message = message
        self.icon = icon
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: MasonSpacing.lg) {
            // Animated icon
            ZStack {
                Circle()
                    .fill(MasonColors.tertiaryBackground)
                    .frame(width: 120, height: 120)
                    .scaleEffect(appeared ? 1.0 : 0.1)
                
                Image(systemName: icon)
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(MasonColors.secondaryLabel)
                    .scaleEffect(appeared ? 1.0 : 0.1)
            }
            .animation(MasonAnimations.bouncy.delay(0.2), value: appeared)
            
            VStack(spacing: MasonSpacing.sm) {
                Text(message)
                    .font(MasonTypography.title3)
                    .foregroundColor(MasonColors.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .opacity(appeared ? 1.0 : 0.0)
                
                if let actionTitle = actionTitle, let action = action {
                    Button(action: action) {
                        Text(actionTitle)
                            .font(MasonTypography.button)
                            .foregroundColor(.white)
                            .padding(.horizontal, MasonSpacing.lg)
                            .padding(.vertical, MasonSpacing.md)
                            .background(MasonColors.primary)
                            .cornerRadius(MasonRadius.md)
                    }
                    .pressableButton()
                    .opacity(appeared ? 1.0 : 0.0)
                }
            }
            .animation(MasonAnimations.gentle.delay(0.4), value: appeared)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(MasonAnimations.gentle) {
                appeared = true
            }
        }
    }
}

// MARK: - Modern Navigation Header
struct ModernNavigationHeader: View {
    let title: String
    let showAddButton: Bool
    let addAction: (() -> Void)?
    
    @State private var appeared = false
    
    var body: some View {
        HStack {
            // App icon and title
            HStack(spacing: MasonSpacing.md) {
                Image(.bee)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .scaleEffect(appeared ? 1.0 : 0.1)
                    .animation(MasonAnimations.bouncy.delay(0.1), value: appeared)
                
                Text("Mason")
                    .font(MasonTypography.title2)
                    .foregroundColor(MasonColors.label)
                    .opacity(appeared ? 1.0 : 0.0)
                    .animation(MasonAnimations.gentle.delay(0.2), value: appeared)
            }
            
            Spacer()
            
            if showAddButton, let addAction = addAction {
                Button(action: addAction) {
                    Image(systemName: "plus")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(MasonColors.primary)
                        .cornerRadius(18)
                        .shadow(
                            color: MasonColors.primary.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                }
                .pressableButton()
                .scaleEffect(appeared ? 1.0 : 0.1)
                .animation(MasonAnimations.bouncy.delay(0.3), value: appeared)
            }
        }
        .onAppear {
            withAnimation(MasonAnimations.gentle) {
                appeared = true
            }
        }
    }
}

// MARK: - Modern Search Bar
struct ModernSearchBar: View {
    @Binding var searchText: String
    let placeholder: String
    
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(MasonColors.secondaryLabel)
                .animation(MasonAnimations.smooth, value: isEditing)
            
            TextField(placeholder, text: $searchText)
                .font(MasonTypography.body)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
                .onTapGesture {
                    withAnimation(MasonAnimations.smooth) {
                        isEditing = true
                    }
                }
            
            if !searchText.isEmpty {
                Button {
                    withAnimation(MasonAnimations.smooth) {
                        searchText = ""
                        isFocused = false
                        isEditing = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(MasonColors.secondaryLabel)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, MasonSpacing.md)
        .padding(.vertical, MasonSpacing.sm)
        .background(MasonColors.tertiaryBackground)
        .cornerRadius(MasonRadius.md)
        .scaleEffect(isEditing ? 1.02 : 1.0)
        .animation(MasonAnimations.smooth, value: isEditing)
        .onChange(of: isFocused) { oldValue, newValue in
            withAnimation(MasonAnimations.smooth) {
                isEditing = newValue
            }
        }
    }
}

// MARK: - Press Events View Modifier
struct PressEvents: ViewModifier {
    let onPressChanged: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
                // On press ended
            } onPressingChanged: { pressing in
                onPressChanged(pressing)
            }
    }
}

extension View {
    func pressEvents(onPressChanged: @escaping (Bool) -> Void) -> some View {
        modifier(PressEvents(onPressChanged: onPressChanged))
    }
}
