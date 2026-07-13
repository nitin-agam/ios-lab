//
//  CreateIssueView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct CreateIssueView: View {
    
    @State private var viewModel: CreateIssueViewModel
    @Environment(\.dismiss) private var dismiss
    let onCreated: (Issue) -> Void
    
    init(owner: String, repo: String, issueService: IssueServiceProtocol, authManager: AuthManager, onCreated: @escaping (Issue) -> Void) {
        _viewModel = State(initialValue: CreateIssueViewModel(owner: owner, repo: repo, issueService: issueService, authManager: authManager))
        self.onCreated = onCreated
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Issue title", text: $viewModel.title)
                }
                Section("Description") {
                    TextEditor(text: $viewModel.body)
                        .frame(minHeight: 120)
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("New Issue")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        Task {
                            if let issue = await viewModel.submit() {
                                onCreated(issue)
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.canSubmit)
                }
            }
        }
    }
}
