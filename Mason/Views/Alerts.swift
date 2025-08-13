//
//  Alerts.swift
//  Mason
//
//  Created by Alexius Academia on 10/20/23.
//

import SwiftUI

// MARK: - Custom Alert Utilities
// This file is reserved for custom alert implementations if needed in the future

struct AlertUtilities {
    
    /// Shows a success alert for task operations
    static func taskSuccessAlert(message: String) -> Alert {
        Alert(
            title: Text("Success"),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
    
    /// Shows an error alert for task operations
    static func taskErrorAlert(message: String) -> Alert {
        Alert(
            title: Text("Error"),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
    
    /// Shows a confirmation alert for destructive actions
    static func confirmationAlert(
        title: String,
        message: String,
        confirmAction: @escaping () -> Void
    ) -> Alert {
        Alert(
            title: Text(title),
            message: Text(message),
            primaryButton: .destructive(Text("Confirm")) {
                confirmAction()
            },
            secondaryButton: .cancel()
        )
    }
}
