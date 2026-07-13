//
//  StarredRepositoriesView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI
import SwiftData

struct StarredRepositoriesView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: StarredRepositoriesViewModel
    let issueService: IssueServiceProtocol
    let repositoryService: RepositoryServiceProtocol
    let authManager: AuthManager
    
    init(repositoryService: RepositoryServiceProtocol, issueService: IssueServiceProtocol, authManager: AuthManager) {
        self.repositoryService = repositoryService
        self.issueService = issueService
        self.authManager = authManager
        _viewModel = State(initialValue: StarredRepositoriesViewModel(repositoryService: repositoryService, authManager: authManager))
    }
    
    var body: some View {
        NavigationStack {
            content
                .task {
                    viewModel.attachCache(StarredRepositoryCache(modelContext: modelContext))
                    await viewModel.loadFirstPage()
                }
                .navigationTitle("Starred")
                .navigationDestination(for: Repository.self) { repo in
                    RepositoryDetailView(repository: repo, issueService: issueService, repositoryService: repositoryService, authManager: authManager)
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
                ForEach(paginated.items) { repo in
                    NavigationLink(value: repo) {
                        RepositoryRow(repository: repo)
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
