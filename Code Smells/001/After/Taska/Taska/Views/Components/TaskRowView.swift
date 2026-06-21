//
//  TaskRowView.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct TaskRowView: View {
    
    let task: AppTask

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .font(.headline)
                .lineLimit(1)
            HStack {
                Text(task.dueDate, format: .dateTime.day().month().year())
                    .font(.caption)
                    .foregroundStyle(task.isOverdue ? .red : .secondary)
                Spacer()
                TaskPriorityBadge(priority: task.priority)
            }
        }
        .padding(.vertical, 2)
    }
}
