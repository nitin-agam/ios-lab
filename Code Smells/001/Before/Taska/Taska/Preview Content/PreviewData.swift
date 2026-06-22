//
//  PreviewData.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

struct MockData {
    
    static let tasks: [AppTask] = [
        AppTask(
            title: "Review PR for authentication module",
            notes: "Check edge cases around token expiry",
            dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            priority: .high),
        AppTask(
            title: "Update onboarding flow copy",
            notes: "Product team has sent revised text",
            dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            priority: .medium),
        AppTask(
            title: "Write unit tests for TaskListViewModel",
            notes: "",
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            priority: .high),
        AppTask(
            title: "Fix crash on iPad landscape rotation",
            notes: "Reported by QA on iPad Pro 12.0",
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            priority: .high),
        AppTask(
            title: "Sync with design on dark mode tokens",
            notes: "",
            dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            priority: .low),
        AppTask(
            title: "Investigate memory spike on task list scroll for more than 50 tasks",
            notes: "Profiler session needed",
            dueDate: Calendar.current.date(byAdding: .day, value: 4, to: Date())!,
            priority: .medium
        )
    ]
    
    static let singleTask = tasks[0]
    static let overdueTask = tasks[0]
    static let emptyTasks: [AppTask] = []
}
