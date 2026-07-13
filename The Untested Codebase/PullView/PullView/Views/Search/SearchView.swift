//
//  SearchView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: SearchViewModel
    private let searchService: SearchServiceProtocol
    private let authManager: AuthManager
    
    init(searchService: SearchServiceProtocol, authManager: AuthManager) {
        self.searchService = searchService
        self.authManager = authManager
        _viewModel = State(initialValue: SearchViewModel(searchService: searchService, authManager: authManager, recentSearchStore: nil))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Scope", selection: $viewModel.scope) {
                    ForEach(SearchScope.allCases, id: \.self) { scope in
                        Text(scope.rawValue).tag(scope)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                content
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.queryText, prompt: "Search GitHub")
            .task {
                viewModel.attachRecentSearchStore(RecentSearchStore(modelContext: modelContext))
            }
            .navigationDestination(for: Repository.self) { repo in
                RepositoryDetailView(repository: repo,
                                     issueService: environment.issueService,
                                     repositoryService: environment.repositoryService,
                                     authManager: environment.authManager)
                
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.scope {
        case .repositories:
            repositoryResults
        case .users:
            userResults
        }
    }
    
    @ViewBuilder
    private var repositoryResults: some View {
        switch viewModel.repositoryState {
        case .idle:
            if viewModel.recentSearches.isEmpty {
                ContentUnavailableView("Search repositories", systemImage: "magnifyingglass")
            } else {
                List(viewModel.recentSearches) { recent in
                    Button(recent.query) {
                        viewModel.queryText = recent.query
                    }
                }
            }
            
        case .loading:
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
    
    @ViewBuilder
    private var userResults: some View {
        switch viewModel.userState {
        case .idle:
            ContentUnavailableView("Search users", systemImage: "person")
        case .loading:
            ProgressView()
        case .loaded(let users):
            List(users) { user in
                Text(user.login)
            }
        case .failed(let message):
            Text(message).foregroundStyle(.red)
        }
    }
}
