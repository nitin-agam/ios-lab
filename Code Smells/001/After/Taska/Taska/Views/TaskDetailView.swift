//
//  TaskDetailView.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    
    let task: AppTask

    var body: some View {
        List {
            Section("Title") {
                Text(task.title)
            }
            
            Section("Details") {
                LabeledContent("Priority", value: task.priority.displayName)
                LabeledContent("Due", value: task.dueDate.formatted(date: .long, time: .omitted))
                LabeledContent("Status", value: task.isCompleted ? "Completed" : "Pending")
            }

            if !task.notes.isEmpty {
                Section("Notes") {
                    Text(task.notes)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("About Task")
        .navigationBarTitleDisplayMode(.large)
    }
}
