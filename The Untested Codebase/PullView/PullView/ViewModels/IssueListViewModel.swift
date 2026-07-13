//
//  IssueListViewModel.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import Observation

enum IssueStateFilter: String, CaseIterable {
    case open = "open"
    case closed = "closed"
    case all = "all"
    
    var displayName: String {
        switch self {
        case .open: return "Open"
        case .closed: return "Closed"
        case .all: return "All"
        }
    }
}

@MainActor
@Observable
final class IssueListViewModel {
    private(set) var state: LoadingState<Paginated<Issue>> = .idle
    var stateFilter: IssueStateFilter = .open {
        didSet { Task { await loadFirstPage() } }
    }
    
    private let owner: String
    private let repo: String
    private let issueService: IssueServiceProtocol
    private let authManager: AuthManager
    
    init(owner: String, repo: String, issueService: IssueServiceProtocol, authManager: AuthManager) {
        self.owner = owner
        self.repo = repo
        self.issueService = issueService
        self.authManager = authManager
    }
    
    func loadFirstPage() async {
        state = .loading
        await loadPage(1, appendingTo: [])
    }
    
    func loadNextPage() async {
        guard case .loaded(let paginated) = state, paginated.hasMorePages else { return }
        await loadPage(paginated.currentPage + 1, appendingTo: paginated.items)
    }
    
    private func loadPage(_ page: Int, appendingTo existing: [Issue]) async {
        do {
            let token = try await authManager.currentToken()
            let newItems = try await issueService.fetchIssues(owner: owner, repo: repo, state: stateFilter.rawValue, page: page, token: token)
            let combined = existing + newItems
            state = .loaded(Paginated(items: combined, currentPage: page, hasMorePages: !newItems.isEmpty))
        } catch {
            state = .failed("Couldn't load issues")
        }
    }
}
