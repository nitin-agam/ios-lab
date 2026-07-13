//
//  IssueListView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct IssueListView: View {
    
    @State private var viewModel: IssueListViewModel
    @State private var isPresentingCreateIssue = false
    private let owner: String
    private let repo: String
    private let issueService: IssueServiceProtocol
    private let authManager: AuthManager
    
    init(owner: String, repo: String, issueService: IssueServiceProtocol, authManager: AuthManager) {
        self.owner = owner
        self.repo = repo
        self.issueService = issueService
        self.authManager = authManager
        _viewModel = State(initialValue: IssueListViewModel(owner: owner, repo: repo, issueService: issueService, authManager: authManager))
    }
    
    var body: some View {
        content
            .task {
                await viewModel.loadFirstPage()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Picker("State", selection: $viewModel.stateFilter) {
                        ForEach(IssueStateFilter.allCases, id: \.self) { filter in
                            Text(filter.displayName).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingCreateIssue = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Issues")
            .sheet(isPresented: $isPresentingCreateIssue) {
                CreateIssueView(owner: owner, repo: repo, issueService: issueService, authManager: authManager) { _ in
                    Task { await viewModel.loadFirstPage() }
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded(let paginated):
            List {
                ForEach(paginated.items) { issue in
                    NavigationLink {
                        IssueDetailView(issue: issue, owner: owner, repo: repo, issueService: issueService, authManager: authManager)
                    } label: {
                        IssueRow(issue: issue)
                    }
                }
                if paginated.hasMorePages {
                    ProgressView()
                        .onAppear {
                            Task { await viewModel.loadNextPage() }
                        }
                }
            }
        case .failed(let message):
            Text(message).foregroundStyle(.red)
        }
    }
}

struct IssueRow: View {
    let issue: Issue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(issue.title)
                .font(.headline)
                .lineLimit(2)
            HStack(spacing: 8) {
                Label(issue.state == .open ? "Open" : "Closed", systemImage: issue.state == .open ? "circle" : "checkmark.circle.fill")
                    .foregroundStyle(issue.state == .open ? .green : .purple)
                Text("#\(issue.number) by \(issue.user.login)")
                    .foregroundStyle(.secondary)
            }
            .font(.caption)
        }
    }
}
