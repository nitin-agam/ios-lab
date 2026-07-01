//
//  TaskPriorityBadge.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct TaskPriorityBadge: View {
    
    let priority: Priority

    private var color: Color {
        switch priority {
        case .high: return AppColor.highPriority
        case .medium: return AppColor.mediumPriority
        case .low: return AppColor.lowPriority
        }
    }
    
    var body: some View {
        Text(priority.displayName)
            .font(AppFont.badge)
            .padding(.horizontal, AppSpacing.small)
            .padding(.vertical, AppSpacing.xxSmall)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
