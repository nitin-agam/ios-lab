//
//  SearchService.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

protocol SearchServiceProtocol {
    func searchRepositories(query: String, page: Int, token: String?) async throws -> SearchResult<Repository>
    func searchUsers(query: String, page: Int, token: String?) async throws -> SearchResult<User>
}

final class SearchService: SearchServiceProtocol {
    private let apiClient: GitHubAPIClientProtocol
    
    init(apiClient: GitHubAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func searchRepositories(query: String, page: Int, token: String?) async throws -> SearchResult<Repository> {
        try await apiClient.request(.searchRepositories(query: query, page: page), token: token)
    }
    
    func searchUsers(query: String, page: Int, token: String?) async throws -> SearchResult<User> {
        try await apiClient.request(.searchUsers(query: query, page: page), token: token)
    }
}
