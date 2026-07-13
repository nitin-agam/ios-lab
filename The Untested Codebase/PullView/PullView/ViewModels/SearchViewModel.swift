//
//  SearchViewModel.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import Combine
import Observation

enum SearchScope: String, CaseIterable {
    case repositories = "Repositories"
    case users = "Users"
}

@MainActor
@Observable
final class SearchViewModel {
    
    var queryText: String = "" {
        didSet { queryTextSubject.send(queryText) }
    }
    var scope: SearchScope = .repositories
    
    private(set) var repositoryState: LoadingState<[Repository]> = .idle
    private(set) var userState: LoadingState<[User]> = .idle
    
    private(set) var recentSearches: [RecentSearch] = []
    
    private let searchService: SearchServiceProtocol
    private let authManager: AuthManager
    private var recentSearchStore: RecentSearchStoreProtocol?
    private let queryTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(searchService: SearchServiceProtocol, authManager: AuthManager, recentSearchStore: RecentSearchStoreProtocol?) {
        self.searchService = searchService
        self.authManager = authManager
        self.recentSearchStore = recentSearchStore
        observeQueryChanges()
    }
    
    func attachRecentSearchStore(_ store: RecentSearchStoreProtocol) {
        recentSearchStore = store
        loadRecentSearches()
    }
    
    func loadRecentSearches() {
        recentSearches = (try? recentSearchStore?.fetchRecent(limit: 10)) ?? []
    }
    
    private func observeQueryChanges() {
        queryTextSubject
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }
                Task { await self.performSearch(text) }
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(_ query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            repositoryState = .idle
            userState = .idle
            return
        }
        
        let token = try? await authManager.currentToken()
        
        switch scope {
        case .repositories:
            repositoryState = .loading
            do {
                let result = try await searchService.searchRepositories(query: query, page: 1, token: token ?? nil)
                repositoryState = .loaded(result.items)
                try? recentSearchStore?.save(query: query, scope: SearchScope.repositories.rawValue)
                loadRecentSearches()
            } catch {
                repositoryState = .failed("Search failed")
            }
        case .users:
            userState = .loading
            do {
                let result = try await searchService.searchUsers(query: query, page: 1, token: token ?? nil)
                userState = .loaded(result.items)
                try? recentSearchStore?.save(query: query, scope: SearchScope.users.rawValue)
                loadRecentSearches()
            } catch {
                userState = .failed("Search failed")
            }
        }
    }
}
