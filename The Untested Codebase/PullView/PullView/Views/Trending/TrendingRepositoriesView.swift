//
//  TrendingRepositoriesView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct TrendingRepositoriesView: View {
    
    @State private var viewModel: TrendingRepositoriesViewModel
    let issueService: IssueServiceProtocol
    let repositoryService: RepositoryServiceProtocol
    let authManager: AuthManager
    
    init(trendingService: TrendingServiceProtocol, repositoryService: RepositoryServiceProtocol, issueService: IssueServiceProtocol, authManager: AuthManager) {
        self.repositoryService = repositoryService
        self.issueService = issueService
        self.authManager = authManager
        _viewModel = State(initialValue: TrendingRepositoriesViewModel(trendingService: trendingService))
    }
    
    var body: some View {
        NavigationStack {
            content
                .task {
                    await viewModel.load()
                }
                .navigationTitle("Trending")
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
        case .loaded(let repos):
            List(repos) { repo in
                NavigationLink(value: repo) {
                    RepositoryRow(repository: repo)
                }
            }
        case .failed(let message):
            Text(message).foregroundStyle(.red)
        }
    }
}
