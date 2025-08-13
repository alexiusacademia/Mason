//
//  DesignSystem.swift
//  Mason
//
//  Created by AI Assistant on 12/26/24.
//  Modern Design System following Apple HIG
//

import SwiftUI

// MARK: - Modern Color Palette
struct MasonColors {
    // Primary Colors - Following iOS 17+ design language
    static let primary = Color(red: 0.0, green: 0.48, blue: 1.0) // iOS Blue
    static let primaryLight = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryDark = Color(red: 0.0, green: 0.3, blue: 0.8)
    
    // Semantic Colors
    static let success = Color(red: 0.2, green: 0.78, blue: 0.35)
    static let warning = Color(red: 1.0, green: 0.58, blue: 0.0)
    static let error = Color(red: 1.0, green: 0.23, blue: 0.19)
    
    // Background Colors - Adaptive for Dark Mode
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    
    // Content Colors
    static let label = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
    static let tertiaryLabel = Color(.tertiaryLabel)
    
    // Card Colors with subtle gradients
    static let todayGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.6, blue: 0.0), Color(red: 1.0, green: 0.8, blue: 0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let previousGradient = LinearGradient(
        colors: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.4, green: 0.8, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let weeklyGradient = LinearGradient(
        colors: [Color(red: 0.2, green: 0.8, blue: 0.4), Color(red: 0.4, green: 1.0, blue: 0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Typography System
struct MasonTypography {
    // Titles
    static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let title1 = Font.system(.title, design: .rounded, weight: .semibold)
    static let title2 = Font.system(.title2, design: .rounded, weight: .semibold)
    static let title3 = Font.system(.title3, design: .rounded, weight: .medium)
    
    // Body Text
    static let body = Font.system(.body, design: .default, weight: .regular)
    static let bodyMedium = Font.system(.body, design: .default, weight: .medium)
    static let bodyBold = Font.system(.body, design: .default, weight: .semibold)
    
    // UI Elements
    static let button = Font.system(.body, design: .rounded, weight: .semibold)
    static let caption = Font.system(.caption, design: .default, weight: .medium)
    static let footnote = Font.system(.footnote, design: .default, weight: .regular)
}

// MARK: - Spacing System
struct MasonSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius System
struct MasonRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 28
}

// MARK: - Shadow System
struct MasonShadows {
    static let subtle = Shadow(
        color: Color.black.opacity(0.05),
        radius: 4,
        x: 0,
        y: 2
    )
    
    static let medium = Shadow(
        color: Color.black.opacity(0.1),
        radius: 8,
        x: 0,
        y: 4
    )
    
    static let strong = Shadow(
        color: Color.black.opacity(0.15),
        radius: 16,
        x: 0,
        y: 8
    )
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Animation Presets
struct MasonAnimations {
    // Spring animations for natural feel
    static let gentle = Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)
    static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)
    
    // Easing animations
    static let smooth = Animation.easeInOut(duration: 0.3)
    static let quick = Animation.easeOut(duration: 0.2)
    static let slow = Animation.easeInOut(duration: 0.5)
    
    // Interactive animations
    static let buttonPress = Animation.easeInOut(duration: 0.1)
    static let cardFlip = Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0)
}

// MARK: - View Modifiers
struct ModernCardStyle: ViewModifier {
    let shadow: Shadow
    
    init(shadow: Shadow = MasonShadows.medium) {
        self.shadow = shadow
    }
    
    func body(content: Content) -> some View {
        content
            .background(MasonColors.background)
            .cornerRadius(MasonRadius.lg)
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
    }
}

struct GlassMorphismStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: MasonRadius.lg)
                    .fill(MasonColors.background.opacity(0.7))
                    .background(.ultraThinMaterial)
            )
            .cornerRadius(MasonRadius.lg)
    }
}

struct PressableButtonStyle: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(MasonAnimations.buttonPress, value: isPressed)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
                // On press
            } onPressingChanged: { pressing in
                isPressed = pressing
            }
    }
}

struct FloatingActionButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 56, height: 56)
            .background(MasonColors.primary)
            .foregroundColor(.white)
            .cornerRadius(28)
            .shadow(
                color: MasonColors.primary.opacity(0.3),
                radius: 12,
                x: 0,
                y: 6
            )
    }
}

// MARK: - View Extensions
extension View {
    func modernCard(shadow: Shadow = MasonShadows.medium) -> some View {
        modifier(ModernCardStyle(shadow: shadow))
    }
    
    func glassMorphism() -> some View {
        modifier(GlassMorphismStyle())
    }
    
    func pressableButton() -> some View {
        modifier(PressableButtonStyle())
    }
    
    func floatingActionButton() -> some View {
        modifier(FloatingActionButtonStyle())
    }
    
    // Smooth appearance animation - simplified to avoid state conflicts
    func smoothAppear(delay: Double = 0) -> some View {
        self
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .offset(y: 20)),
                removal: .opacity
            ))
            .animation(MasonAnimations.gentle.delay(delay), value: true)
    }
    
    // Haptic feedback
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: style)
            impactFeedback.impactOccurred()
        }
    }
}

// MARK: - Accessibility Helpers
struct AccessibilityHelper {
    static func taskRowAccessibility(task: Task, isCompleted: Bool) -> some View {
        EmptyView()
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(task.taskName)")
            .accessibilityValue(isCompleted ? "Completed" : "Incomplete")
            .accessibilityHint(isCompleted ? "Double tap to mark as incomplete" : "Double tap to mark as complete")
            .accessibilityAddTraits(isCompleted ? .isSelected : [])
    }
    
    static func summaryCardAccessibility(title: String, count: Int) -> some View {
        EmptyView()
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(title) tasks")
            .accessibilityValue("\(count) tasks")
            .accessibilityHint("Double tap to view \(title.lowercased()) tasks")
            .accessibilityAddTraits(.isButton)
    }
}
