//
//  TaskListView.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

// MARK: - Task List View
//
// TaskListView is now a thin compositor. Its only job is to read the
// screen's state and route to the right component for each case.
//
// The rendering responsibilities that used to live here have moved out:
// - Loading, error, and empty states are now dedicated Views
// - Task row layout lives in TaskRowView
// - Priority color and badge rendering live in TaskPriorityBadge
// - The overdue rule is now AppTask.isOverdue on the model
//
// Screen state is modeled with LoadingState<[AppTask]> in the ViewModel,
// so loading, error, and loaded can no longer overlap. The body drives an
// exhaustive switch over that state, and the compiler guarantees every
// case is handled. Empty is checked inside .loaded, since an empty result
// is a property of loaded data, not a separate state of its own.

struct TaskListView: View {
    
    @State private var viewModel = TaskListViewModel()
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Tasks")
                .searchable(text: $viewModel.searchText, prompt: "Search tasks")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddTask = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddTask) {
                    AddTaskView { newTask in
                        viewModel.addTask(newTask)
                    }
                }
                .task {
                    await viewModel.loadTasks()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            TaskLoadingView()
            
        case .error(let message):
            TaskErrorView(message: message) {
                Task { await viewModel.loadTasks() }
            }
            
        case .loaded(let tasks):
            let visible = viewModel.filtered(tasks)
            if visible.isEmpty {
                TaskEmptyStateView()
            } else {
                List {
                    ForEach(visible) { task in
                        NavigationLink(destination: TaskDetailView(task: task)) {
                            TaskRowView(task: task)
                        }
                    }
                    .onDelete { indexSet in
                        Task {
                            for index in indexSet {
                                await viewModel.deleteTask(visible[index])
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

// MARK: - Previews
#Preview("Task list (loaded)") {
    TaskListView()
}

#Preview("Task detail") {
    NavigationStack {
        TaskDetailView(task: MockData.singleTask)
    }
}

