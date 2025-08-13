//
//  AccessibilityManager.swift
//  Mason
//
//  Created by AI Assistant on 12/26/24.
//  Comprehensive accessibility support following Apple guidelines
//

import SwiftUI
import UIKit

// MARK: - Accessibility Manager
@MainActor
class AccessibilityManager: ObservableObject {
    @Published var isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
    @Published var preferredContentSizeCategory = UIApplication.shared.preferredContentSizeCategory
    @Published var isDarkModeEnabled = UITraitCollection.current.userInterfaceStyle == .dark
    @Published var isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
    @Published var isBoldTextEnabled = UIAccessibility.isBoldTextEnabled
    @Published var isHighContrastEnabled = UIAccessibility.isDarkerSystemColorsEnabled
    
    init() {
        setupAccessibilityNotifications()
    }
    
    private func setupAccessibilityNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
        }
        
        NotificationCenter.default.addObserver(
            forName: UIContentSizeCategory.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.preferredContentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        }
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
        }
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.boldTextStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isBoldTextEnabled = UIAccessibility.isBoldTextEnabled
        }
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.darkerSystemColorsStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isHighContrastEnabled = UIAccessibility.isDarkerSystemColorsEnabled
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Accessibility Utilities
struct AccessibilityUtils {
    
    // MARK: - VoiceOver Announcements
    static func announce(_ message: String, priority: UIAccessibility.AnnouncementPriority = .medium) {
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
    
    static func announceScreenChange(to element: Any? = nil) {
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .screenChanged, argument: element)
        }
    }
    
    static func announceLayoutChange(to element: Any? = nil) {
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .layoutChanged, argument: element)
        }
    }
    
    // MARK: - Task-specific Announcements
    static func announceTaskCompleted(_ taskName: String) {
        announce("Task completed: \(taskName)", priority: .high)
    }
    
    static func announceTaskAdded(_ taskName: String) {
        announce("New task added: \(taskName)", priority: .medium)
    }
    
    static func announceTaskDeleted(_ taskName: String) {
        announce("Task deleted: \(taskName)", priority: .medium)
    }
    
    static func announceSearchResults(count: Int, searchTerm: String) {
        let message = count == 0 
            ? "No tasks found for '\(searchTerm)'"
            : "Found \(count) task\(count == 1 ? "" : "s") for '\(searchTerm)'"
        announce(message)
    }
}

// MARK: - Accessibility Labels and Hints
struct AccessibilityLabels {
    
    // MARK: - Task-related Labels
    static func taskRowLabel(taskName: String, isCompleted: Bool, date: String? = nil) -> String {
        var label = "Task: \(taskName)"
        if let date = date {
            label += ", scheduled for \(date)"
        }
        label += isCompleted ? ", completed" : ", pending"
        return label
    }
    
    static func taskToggleHint(isCompleted: Bool) -> String {
        return isCompleted ? "Double tap to mark as incomplete" : "Double tap to mark as complete"
    }
    
    static func taskEditHint() -> String {
        return "Double tap to edit task details"
    }
    
    static func taskDeleteHint() -> String {
        return "Swipe up with one finger to delete task"
    }
    
    // MARK: - Navigation Labels
    static func summaryCardLabel(title: String, count: Int) -> String {
        return "\(title) section, \(count) task\(count == 1 ? "" : "s")"
    }
    
    static func summaryCardHint() -> String {
        return "Double tap to view tasks in this section"
    }
    
    static func searchBarLabel() -> String {
        return "Search tasks"
    }
    
    static func searchBarHint() -> String {
        return "Type to filter tasks by name"
    }
    
    static func addTaskButtonLabel() -> String {
        return "Add new task"
    }
    
    static func addTaskButtonHint() -> String {
        return "Double tap to create a new task"
    }
}

// MARK: - Dynamic Type Support
extension Font {
    static func accessibleTitle() -> Font {
        return .title.weight(.bold)
    }
    
    static func accessibleTitle2() -> Font {
        return .title2.weight(.semibold)
    }
    
    static func accessibleTitle3() -> Font {
        return .title3.weight(.medium)
    }
    
    static func accessibleBody() -> Font {
        return .body
    }
    
    static func accessibleCaption() -> Font {
        return .caption
    }
}

// MARK: - High Contrast Colors
extension Color {
    static func accessiblePrimary(isHighContrast: Bool) -> Color {
        return isHighContrast ? .primary : MasonColors.primary
    }
    
    static func accessibleSecondary(isHighContrast: Bool) -> Color {
        return isHighContrast ? .secondary : MasonColors.secondaryLabel
    }
    
    static func accessibleBackground(isHighContrast: Bool) -> Color {
        return isHighContrast ? .black : MasonColors.background
    }
    
    static func accessibleCardBackground(isHighContrast: Bool) -> Color {
        return isHighContrast ? .white : MasonColors.cardBackground
    }
}

// MARK: - Accessibility View Modifiers
extension View {
    
    // MARK: - VoiceOver Support
    func accessibleTaskRow(
        taskName: String,
        isCompleted: Bool,
        date: String? = nil,
        onToggle: @escaping () -> Void,
        onEdit: @escaping () -> Void
    ) -> some View {
        self
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(AccessibilityLabels.taskRowLabel(
                taskName: taskName,
                isCompleted: isCompleted,
                date: date
            ))
            .accessibilityHint(AccessibilityLabels.taskToggleHint(isCompleted: isCompleted))
            .accessibilityAddTraits(isCompleted ? .isSelected : [])
            .accessibilityAction(named: "Toggle completion") {
                onToggle()
            }
            .accessibilityAction(named: "Edit task") {
                onEdit()
            }
    }
    
    func accessibleSummaryCard(
        title: String,
        count: Int,
        onTap: @escaping () -> Void
    ) -> some View {
        self
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(AccessibilityLabels.summaryCardLabel(title: title, count: count))
            .accessibilityHint(AccessibilityLabels.summaryCardHint())
            .accessibilityAddTraits(.isButton)
            .accessibilityAction {
                onTap()
            }
    }
    
    func accessibleSearchBar(searchText: Binding<String>) -> some View {
        self
            .accessibilityLabel(AccessibilityLabels.searchBarLabel())
            .accessibilityHint(AccessibilityLabels.searchBarHint())
    }
    
    func accessibleAddButton(onTap: @escaping () -> Void) -> some View {
        self
            .accessibilityLabel(AccessibilityLabels.addTaskButtonLabel())
            .accessibilityHint(AccessibilityLabels.addTaskButtonHint())
            .accessibilityAddTraits(.isButton)
            .accessibilityAction {
                onTap()
            }
    }
    
    // MARK: - Dynamic Type Support
    func dynamicTypeSize() -> some View {
        self.dynamicTypeSize(...DynamicTypeSize.accessibility3)
    }
    
    // MARK: - Reduce Motion Support
    func conditionalAnimation<V: Equatable>(
        _ animation: Animation?,
        value: V,
        isReduceMotionEnabled: Bool
    ) -> some View {
        self.animation(isReduceMotionEnabled ? nil : animation, value: value)
    }
    
    func conditionalTransition(
        _ transition: AnyTransition,
        isReduceMotionEnabled: Bool
    ) -> some View {
        self.transition(isReduceMotionEnabled ? .identity : transition)
    }
    
    // MARK: - Focus Management
    func accessibilityFocusable(_ isFocused: Bool = true) -> some View {
        self.focusable(isFocused)
    }
    
    // MARK: - Keyboard Navigation
    func keyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = []) -> some View {
        self.keyboardShortcut(key, modifiers: modifiers)
    }
}

// MARK: - Accessibility Constants
struct AccessibilityConstants {
    static let minimumTouchTargetSize: CGFloat = 44.0
    static let preferredTouchTargetSize: CGFloat = 48.0
    static let maximumLineLimit = 0 // No limit for accessibility
    static let minimumContrast: Double = 4.5
    
    // Common accessibility identifiers
    struct Identifiers {
        static let taskRow = "task_row"
        static let summaryCard = "summary_card"
        static let searchBar = "search_bar"
        static let addButton = "add_button"
        static let editButton = "edit_button"
        static let deleteButton = "delete_button"
        static let toggleButton = "toggle_button"
    }
}
