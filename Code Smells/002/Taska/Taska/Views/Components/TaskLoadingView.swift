//
//  TaskLoadingView.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct TaskLoadingView: View {
    
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
            Text("Loading tasks...")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
