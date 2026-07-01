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
        VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
            Text(task.title)
                .font(AppFont.rowTitle)
                .lineLimit(1)
            HStack {
                Text(task.dueDate, format: .dateTime.day().month().year())
                    .font(AppFont.rowDetail)
                    .foregroundStyle(task.isOverdue ? AppColor.overdue : AppColor.secondaryText)
                Spacer()
                TaskPriorityBadge(priority: task.priority)
            }
        }
        .padding(.vertical, AppSpacing.xxSmall)
    }
}
