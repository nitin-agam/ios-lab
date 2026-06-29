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
    
    var state: LoadingState<[AppTask]> = .idle
    var searchText: String = ""
    
    func filtered(_ tasks: [AppTask]) -> [AppTask] {
        guard !searchText.isEmpty else { return tasks }
        return tasks.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    func loadTasks() async {
        state = .loading

        // perform network request here to fetch tasks
        // simulating a network delay with mock data
        try? await Task.sleep(for: .seconds(1))

        state = .loaded(MockData.tasks)
    }
    
    func addTask(_ task: AppTask) {
        if case .loaded(var tasks) = state {
            tasks.append(task)
            state = .loaded(tasks)
        } else {
            state = .loaded([task])
        }
    }

    func deleteTask(_ task: AppTask) async {
        guard case .loaded(var tasks) = state else { return }
        
        // perform network request here to delete task
        // simulating a delete call
        try? await Task.sleep(for: .milliseconds(300))
        
        tasks.removeAll { $0.id == task.id }
        state = .loaded(tasks)
    }
}
