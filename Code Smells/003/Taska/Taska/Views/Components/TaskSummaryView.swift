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
                .font(AppFont.summary)
                .foregroundStyle(AppColor.secondaryText)

            Spacer()

            if let next = tasks.min(by: { $0.dueDate < $1.dueDate }) {
                Text(next.dueDateDisplay.text)
                    .font(AppFont.summary)
                    .foregroundStyle(next.dueDateDisplay.isOverdue ? AppColor.overdue : AppColor.secondaryText)
            }
        }
        .padding(.horizontal, AppSpacing.large)
        .padding(.vertical, AppSpacing.medium)
    }
}

#Preview {
    TaskSummaryView(tasks: MockData.tasks)
}
