//
//  AppTask+Display.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

extension AppTask {

    // single source of truth for how a due date should read on screen
    // built on top of isOverdue, not a separate date comparison
    var dueDateDisplay: DueDateDisplay {
        let calendar = Calendar.current

        if calendar.isDateInToday(dueDate) {
            return .dueToday
        } else if calendar.isDateInTomorrow(dueDate) {
            return .dueTomorrow
        } else if isOverdue {
            let days = calendar.dateComponents([.day], from: dueDate, to: Date()).day ?? 0
            return .overdueBy(days)
        } else {
            let days = calendar.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
            return .dueInDays(days)
        }
    }

    // single source of truth for how a task's completion status reads on screen.
    var statusDisplay: String {
        isCompleted ? "Completed" : "Pending"
    }
}
