//
//  RepositoryListView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct RepositoryListView: View {
    
    @State private var viewModel: RepositoryListViewModel
    
    init(username: String, repositoryService: RepositoryServiceProtocol, authManager: AuthManager) {
        _viewModel = State(initialValue: RepositoryListViewModel(username: username, repositoryService: repositoryService, authManager: authManager))
    }
    
    var body: some View {
        content
            .task {
                await viewModel.loadFirstPage()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $viewModel.sortOption) {
                            ForEach(RepositorySortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded:
            list
        case .failed(let message):
            Text(message).foregroundStyle(.red)
        }
    }
    
    private var list: some View {
        List {
            ForEach(viewModel.visibleRepositories) { repo in
                NavigationLink(value: repo) {
                    RepositoryRow(repository: repo)
                }
            }
            
            if case .loaded(let paginated) = viewModel.state, paginated.hasMorePages {
                ProgressView()
                    .onAppear {
                        Task { await viewModel.loadNextPage() }
                    }
            }
        }
    }
}

struct RepositoryRow: View {
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(repository.name)
                .font(.headline)
            if let description = repository.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            HStack(spacing: 12) {
                if let language = repository.language {
                    Label(language, systemImage: "circle.fill")
                        .font(.caption)
                }
                Label("\(repository.stargazersCount)", systemImage: "star")
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
        }
    }
}
