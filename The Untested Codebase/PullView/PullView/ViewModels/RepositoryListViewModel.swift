//
//  RepositoryListViewModel.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import Observation

enum RepositorySortOption: String, CaseIterable {
    case updated = "Recently updated"
    case stars = "Most stars"
    case name = "Name"
}

@MainActor
@Observable
final class RepositoryListViewModel {
    
    private(set) var state: LoadingState<Paginated<Repository>> = .idle
    var sortOption: RepositorySortOption = .updated
    var languageFilter: String?
    
    private let username: String
    private let repositoryService: RepositoryServiceProtocol
    private let authManager: AuthManager
    
    init(username: String, repositoryService: RepositoryServiceProtocol, authManager: AuthManager) {
        self.username = username
        self.repositoryService = repositoryService
        self.authManager = authManager
    }
    
    var visibleRepositories: [Repository] {
        guard case .loaded(let paginated) = state else { return [] }
        
        var result = paginated.items
        if let languageFilter, !languageFilter.isEmpty {
            result = result.filter { $0.language == languageFilter }
        }
        
        switch sortOption {
        case .updated:
            result.sort { $0.updatedAt > $1.updatedAt }
        case .stars:
            result.sort { $0.stargazersCount > $1.stargazersCount }
        case .name:
            result.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
        return result
    }
    
    func loadFirstPage() async {
        state = .loading
        await loadPage(1, appendingTo: [])
    }
    
    func loadNextPage() async {
        guard case .loaded(let paginated) = state, paginated.hasMorePages else { return }
        await loadPage(paginated.currentPage + 1, appendingTo: paginated.items)
    }
    
    private func loadPage(_ page: Int, appendingTo existing: [Repository]) async {
        do {
            let token = try await authManager.currentToken()
            let newItems = try await repositoryService.fetchRepositories(username: username, page: page, token: token)
            let combined = existing + newItems
            state = .loaded(Paginated(items: combined, currentPage: page, hasMorePages: !newItems.isEmpty))
        } catch {
            state = .failed("Couldn't load repositories")
        }
    }
}
