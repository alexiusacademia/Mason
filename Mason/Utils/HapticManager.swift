//
//  HapticManager.swift
//  Mason
//
//  Created by AI Assistant on 12/26/24.
//  Comprehensive haptic feedback system for enhanced user experience
//

import UIKit
import SwiftUI

// MARK: - Haptic Manager
@MainActor
class HapticManager: ObservableObject {
    
    // MARK: - Haptic Generators
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    // MARK: - Settings
    @Published var isHapticEnabled = true
    @Published var hapticIntensity: HapticIntensity = .medium
    
    enum HapticIntensity: String, CaseIterable {
        case light = "Light"
        case medium = "Medium"
        case strong = "Strong"
        case off = "Off"
    }
    
    // MARK: - Initialization
    init() {
        prepareHaptics()
        loadSettings()
    }
    
    private func prepareHaptics() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    private func loadSettings() {
        if let savedIntensity = UserDefaults.standard.object(forKey: "haptic_intensity") as? String,
           let intensity = HapticIntensity(rawValue: savedIntensity) {
            hapticIntensity = intensity
        }
        
        isHapticEnabled = UserDefaults.standard.bool(forKey: "haptic_enabled")
        
        // Default to enabled if not set
        if UserDefaults.standard.object(forKey: "haptic_enabled") == nil {
            isHapticEnabled = true
            UserDefaults.standard.set(true, forKey: "haptic_enabled")
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(isHapticEnabled, forKey: "haptic_enabled")
        UserDefaults.standard.set(hapticIntensity.rawValue, forKey: "haptic_intensity")
    }
    
    // MARK: - Core Haptic Methods
    private func performHaptic(_ haptic: () -> Void) {
        guard isHapticEnabled && hapticIntensity != .off else { return }
        haptic()
    }
    
    // MARK: - Task-Related Haptics
    
    /// Haptic feedback when a task is completed
    func taskCompleted() {
        performHaptic {
            switch hapticIntensity {
            case .light:
                impactLight.impactOccurred()
            case .medium:
                impactMedium.impactOccurred()
            case .strong:
                impactHeavy.impactOccurred()
            case .off:
                break
            }
            
            // Add a slight delay and success notification for completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.notificationGenerator.notificationOccurred(.success)
            }
        }
    }
    
    /// Haptic feedback when a task is uncompleted
    func taskUncompleted() {
        performHaptic {
            switch hapticIntensity {
            case .light:
                impactLight.impactOccurred()
            case .medium, .strong:
                impactMedium.impactOccurred()
            case .off:
                break
            }
        }
    }
    
    /// Haptic feedback when a new task is added
    func taskAdded() {
        performHaptic {
            notificationGenerator.notificationOccurred(.success)
        }
    }
    
    /// Haptic feedback when a task is deleted
    func taskDeleted() {
        performHaptic {
            switch hapticIntensity {
            case .light:
                impactLight.impactOccurred()
            case .medium:
                impactMedium.impactOccurred()
            case .strong:
                impactHeavy.impactOccurred()
                // Add warning notification for stronger feedback
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.notificationGenerator.notificationOccurred(.warning)
                }
            case .off:
                break
            }
        }
    }
    
    /// Haptic feedback when a task is edited/updated
    func taskUpdated() {
        performHaptic {
            impactLight.impactOccurred()
        }
    }
    
    // MARK: - UI Interaction Haptics
    
    /// Light haptic for button presses
    func buttonPressed() {
        performHaptic {
            impactLight.impactOccurred()
        }
    }
    
    /// Selection haptic for picker/segmented controls
    func selectionChanged() {
        performHaptic {
            selectionGenerator.selectionChanged()
        }
    }
    
    /// Haptic for swipe actions
    func swipeAction() {
        performHaptic {
            impactMedium.impactOccurred()
        }
    }
    
    /// Haptic for pull to refresh
    func pullToRefresh() {
        performHaptic {
            impactLight.impactOccurred()
        }
    }
    
    /// Haptic for scroll to top
    func scrollToTop() {
        performHaptic {
            impactLight.impactOccurred()
        }
    }
    
    // MARK: - Navigation Haptics
    
    /// Haptic for tab switching
    func tabSwitched() {
        performHaptic {
            selectionGenerator.selectionChanged()
        }
    }
    
    /// Haptic for modal presentation
    func modalPresented() {
        performHaptic {
            impactLight.impactOccurred()
        }
    }
    
    /// Haptic for modal dismissal
    func modalDismissed() {
        performHaptic {
            impactLight.impactOccurred()
        }
    }
    
    // MARK: - Error and Success Haptics
    
    /// Success haptic for positive actions
    func success() {
        performHaptic {
            notificationGenerator.notificationOccurred(.success)
        }
    }
    
    /// Warning haptic for cautionary actions
    func warning() {
        performHaptic {
            notificationGenerator.notificationOccurred(.warning)
        }
    }
    
    /// Error haptic for failed actions
    func error() {
        performHaptic {
            notificationGenerator.notificationOccurred(.error)
        }
    }
    
    // MARK: - Search Haptics
    
    /// Haptic when search finds results
    func searchResultsFound() {
        performHaptic {
            impactLight.impactOccurred()
        }
    }
    
    /// Haptic when search finds no results
    func searchNoResults() {
        performHaptic {
            impactMedium.impactOccurred()
        }
    }
    
    /// Haptic when clearing search
    func searchCleared() {
        performHaptic {
            impactLight.impactOccurred()
        }
    }
    
    // MARK: - Long Press and Gesture Haptics
    
    /// Haptic for long press start
    func longPressStarted() {
        performHaptic {
            impactMedium.impactOccurred()
        }
    }
    
    /// Haptic for drag start
    func dragStarted() {
        performHaptic {
            impactMedium.impactOccurred()
        }
    }
    
    /// Haptic for drag ended
    func dragEnded() {
        performHaptic {
            impactLight.impactOccurred()
        }
    }
}

// MARK: - Haptic View Modifiers
extension View {
    
    /// Add haptic feedback to button press
    func hapticFeedback(
        _ hapticManager: HapticManager,
        type: HapticFeedbackType = .button
    ) -> some View {
        self.simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    switch type {
                    case .button:
                        hapticManager.buttonPressed()
                    case .selection:
                        hapticManager.selectionChanged()
                    case .success:
                        hapticManager.success()
                    case .error:
                        hapticManager.error()
                    case .warning:
                        hapticManager.warning()
                    }
                }
        )
    }
    
    /// Add haptic feedback to task toggle
    func taskToggleHaptic(
        _ hapticManager: HapticManager,
        isCompleted: Bool
    ) -> some View {
        self.onChange(of: isCompleted) { _, newValue in
            if newValue {
                hapticManager.taskCompleted()
            } else {
                hapticManager.taskUncompleted()
            }
        }
    }
    
    /// Add haptic feedback to swipe actions
    func swipeHaptic(_ hapticManager: HapticManager) -> some View {
        self.simultaneousGesture(
            DragGesture()
                .onChanged { _ in
                    hapticManager.swipeAction()
                }
        )
    }
}

// MARK: - Haptic Feedback Types
enum HapticFeedbackType {
    case button
    case selection
    case success
    case error
    case warning
}

// MARK: - Haptic Settings View
struct HapticSettingsView: View {
    @StateObject private var hapticManager = HapticManager()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Haptic Feedback")) {
                    Toggle("Enable Haptic Feedback", isOn: $hapticManager.isHapticEnabled)
                        .onChange(of: hapticManager.isHapticEnabled) { _, _ in
                            hapticManager.saveSettings()
                        }
                    
                    if hapticManager.isHapticEnabled {
                        Picker("Intensity", selection: $hapticManager.hapticIntensity) {
                            ForEach(HapticManager.HapticIntensity.allCases.filter { $0 != .off }, id: \.self) { intensity in
                                Text(intensity.rawValue).tag(intensity)
                            }
                        }
                        .onChange(of: hapticManager.hapticIntensity) { _, _ in
                            hapticManager.saveSettings()
                            hapticManager.selectionChanged()
                        }
                    }
                }
                
                if hapticManager.isHapticEnabled {
                    Section(header: Text("Test Haptics")) {
                        Button("Test Light Haptic") {
                            hapticManager.buttonPressed()
                        }
                        
                        Button("Test Task Completion") {
                            hapticManager.taskCompleted()
                        }
                        
                        Button("Test Success") {
                            hapticManager.success()
                        }
                        
                        Button("Test Error") {
                            hapticManager.error()
                        }
                    }
                }
                
                Section(footer: Text("Haptic feedback provides tactile responses to your interactions, making the app feel more responsive and engaging.")) {
                    EmptyView()
                }
            }
            .navigationTitle("Haptic Settings")
        }
    }
}
