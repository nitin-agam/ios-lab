//
//  TaskListViewModel.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
class TaskListViewModel {

    var tasks: [AppTask] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var searchText: String = ""

    var filteredTasks: [AppTask] {
        guard !searchText.isEmpty else { return tasks }
        return tasks.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    func loadTasks() async {
        isLoading = true
        errorMessage = nil

        // perform network request here to fetch tasks
        // simulating a network delay with mock data
        try? await Task.sleep(for: .seconds(1))

        tasks = MockData.tasks
        isLoading = false
    }

    func addTask(_ task: AppTask) {
        tasks.append(task)
    }

    func deleteTask(_ task: AppTask) async {
        // perform network request here to delete task
        // simulating a delete call
        try? await Task.sleep(for: .milliseconds(300))
        tasks.removeAll { $0.id == task.id }
    }
}
