//
//  TaskSummaryView.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct TaskSummaryView: View {
    
    let tasks: [AppTask]

    var body: some View {
        HStack {
            Text(pluralized(tasks.count, singular: "task") + " remaining")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            if let next = tasks.min(by: { $0.dueDate < $1.dueDate }) {
                Text(next.dueDateDisplay.text)
                    .font(.subheadline)
                    .foregroundStyle(next.dueDateDisplay.isOverdue ? .red : .secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    TaskSummaryView(tasks: MockData.tasks)
}
