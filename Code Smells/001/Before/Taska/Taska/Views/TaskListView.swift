//
//  TaskListView.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

// MARK: - God View
//
// This is the "Before Fix" state.
//
// TaskListViewModel correctly owns the data layer like fetching, filtering, deleting tasks.
//
// But TaskListView itself has become a God View. It owns:
// - Rendering of three separate UI states (loading, error, empty)
// - Task row layout inside ForEach with date formatting logic
// - Business rule: dueDate < Date() to decide text color
// - Priority color mapping via a private helper function
// - Priority badge rendering (Text + Capsule) inline in the row
// - Navigation destination built inline inside NavigationLink
//
// None of these are business logic mistakes. The ViewModel is fine.
// The smell is entirely in how much rendering responsibility this single View has accumulated.

struct TaskListView: View {

    @State private var viewModel = TaskListViewModel()
    @State private var showingAddTask = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    // loading state
                    VStack(spacing: 12) {
                        ProgressView()
                            .controlSize(.large)
                        Text("Loading tasks...")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if let error = viewModel.errorMessage {
                    // error state
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundStyle(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Retry") {
                            Task { await viewModel.loadTasks() }
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if viewModel.filteredTasks.isEmpty {
                    // empty state
                    VStack(spacing: 8) {
                        Image(systemName: "checklist")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No tasks yet")
                            .font(.headline)
                        Text("Tap + to add your first task")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    List {
                        ForEach(viewModel.filteredTasks) { task in
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                // row layout owned entirely inline
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title)
                                        .font(.headline)
                                        .lineLimit(1)

                                    HStack {
                                        Text(task.priority.displayName)
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(priorityColor(task.priority).opacity(0.15))
                                            .foregroundStyle(priorityColor(task.priority))
                                            .clipShape(Capsule())
                                        
                                        Text(task.dueDate, format: .dateTime.day().month().year())
                                            .font(.caption)
                                            .foregroundStyle(task.dueDate < Date() ? .red : .secondary)

                                        Spacer()
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                for index in indexSet {
                                    await viewModel.deleteTask(viewModel.filteredTasks[index])
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
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

    // priority color logic sitting in the View as a private helper
    // this belongs closer to the data either on Priority itself
    // or inside a dedicated component but here it lives in the View
    private func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
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

