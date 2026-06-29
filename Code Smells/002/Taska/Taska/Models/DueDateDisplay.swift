//
//  DueDateDisplay.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

enum DueDateDisplay {
    
    case dueToday
    case dueTomorrow
    case dueInDays(Int)
    case overdueBy(Int)

    var text: String {
        switch self {
        case .dueToday:
            return "Due today"
        case .dueTomorrow:
            return "Due tomorrow"
        case .dueInDays(let days):
            return "Due in \(days) day\(days == 1 ? "" : "s")"
        case .overdueBy(let days):
            return "Overdue by \(days) day\(days == 1 ? "" : "s")"
        }
    }

    var isOverdue: Bool {
        if case .overdueBy = self { return true }
        return false
    }
}
