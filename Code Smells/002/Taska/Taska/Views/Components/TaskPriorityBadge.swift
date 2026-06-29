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
        case .high:   return .red
        case .medium: return .orange
        case .low:    return .green
        }
    }

    var body: some View {
        Text(priority.displayName)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
