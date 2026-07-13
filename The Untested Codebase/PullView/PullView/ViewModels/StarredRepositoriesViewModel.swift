//
//  StarredRepositoriesViewModel.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import Observation

// This is the real "offline-first" behavior worth dwelling on in the article: cache is shown optimistically, network is the source of truth once it responds, and a network failure after a successful cache read doesn't clobber what's already on screen. That last point is a deliberate product decision, not an incidental side effect — showing a stale list beats showing an error when the user already has something to look at.

// One limitation to flag honestly: refreshFromNetwork only fetches page 1 and treats that as the full replacement for the cache. If a user has starred repos across multiple pages, only the first page survives a cache refresh. Fixing that properly means paginating through the entire starred list before clearing the cache — doable, but adds real complexity for a demo app. Worth deciding now: leave this as a known, stated limitation (good for an article callout), or handle full pagination on refresh?

@MainActor
@Observable
final class StarredRepositoriesViewModel {
    private(set) var state: LoadingState<Paginated<Repository>> = .idle
    
    private let repositoryService: RepositoryServiceProtocol
    private let authManager: AuthManager
    private var cache: StarredRepositoryCacheProtocol?
    
    init(repositoryService: RepositoryServiceProtocol, authManager: AuthManager) {
        self.repositoryService = repositoryService
        self.authManager = authManager
    }
    
    func attachCache(_ cache: StarredRepositoryCacheProtocol) {
        self.cache = cache
    }
    
    func loadFirstPage() async {
        // Show cached data immediately if we have it, then refresh from network in the background.
        if let cached = try? cache?.fetchAll(), !cached.isEmpty {
            state = .loaded(Paginated(items: cached, currentPage: 1, hasMorePages: false))
        } else {
            state = .loading
        }
        await refreshFromNetwork()
    }
    
    func loadNextPage() async {
        guard case .loaded(let paginated) = state, paginated.hasMorePages else { return }
        await loadPage(paginated.currentPage + 1, appendingTo: paginated.items)
    }
    
    private func refreshFromNetwork() async {
        do {
            guard let token = try await authManager.currentToken() else {
                // Offline or signed out with no cache — only surface an error if we truly have nothing to show.
                if case .loading = state {
                    state = .failed("Not signed in")
                }
                return
            }
            let newItems = try await repositoryService.fetchStarredRepositories(page: 1, token: token)
            state = .loaded(Paginated(items: newItems, currentPage: 1, hasMorePages: !newItems.isEmpty))
            try? cache?.clear()
            try? cache?.save(newItems)
        } catch {
            // Network failed — if we already showed cached data above, leave it displayed rather than overwriting with an error.
            if case .loading = state {
                state = .failed("Couldn't load starred repositories")
            }
        }
    }
    
    private func loadPage(_ page: Int, appendingTo existing: [Repository]) async {
        do {
            guard let token = try await authManager.currentToken() else {
                state = .failed("Not signed in")
                return
            }
            let newItems = try await repositoryService.fetchStarredRepositories(page: page, token: token)
            let combined = existing + newItems
            state = .loaded(Paginated(items: combined, currentPage: page, hasMorePages: !newItems.isEmpty))
        } catch {
            state = .failed("Couldn't load starred repositories")
        }
    }
}
