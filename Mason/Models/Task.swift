//
//  Task.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import Foundation
import SwiftUI


class Task {
    var timestamp: Date
    var taskName: String
    var completed: Bool
    
    init(timestamp: Date = .now, taskName: String) {
        self.timestamp = timestamp
        self.taskName = taskName
        self.completed = false
    }
}
