//
//  Task.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

struct AppTask: Identifiable, Codable {
    
    let id: UUID
    var title: String
    var notes: String
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    
    init(id: UUID = UUID(),
         title: String,
         notes: String = "",
         dueDate: Date,
         priority: Priority = .medium,
         isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
    }
}
