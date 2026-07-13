//
//  RepositoryService.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

protocol RepositoryServiceProtocol {
    func fetchRepositories(username: String, page: Int, token: String?) async throws -> [Repository]
    func fetchRepositoryDetail(owner: String, repo: String, token: String?) async throws -> Repository
    func fetchStarredRepositories(page: Int, token: String) async throws -> [Repository]
    func starRepository(owner: String, repo: String, token: String) async throws
    func unstarRepository(owner: String, repo: String, token: String) async throws
    func isRepositoryStarred(owner: String, repo: String, token: String) async throws -> Bool
}

final class RepositoryService: RepositoryServiceProtocol {
    private let apiClient: GitHubAPIClientProtocol
    
    init(apiClient: GitHubAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchRepositories(username: String, page: Int, token: String?) async throws -> [Repository] {
        try await apiClient.request(.repositories(username: username, page: page), token: token)
    }
    
    func fetchRepositoryDetail(owner: String, repo: String, token: String?) async throws -> Repository {
        try await apiClient.request(.repositoryDetail(owner: owner, repo: repo), token: token)
    }
    
    func fetchStarredRepositories(page: Int, token: String) async throws -> [Repository] {
        try await apiClient.request(.starredRepositories(page: page), token: token)
    }
    
    func starRepository(owner: String, repo: String, token: String) async throws {
        try await apiClient.requestNoContent(.starRepository(owner: owner, repo: repo), token: token)
    }
    
    func unstarRepository(owner: String, repo: String, token: String) async throws {
        try await apiClient.requestNoContent(.unstarRepository(owner: owner, repo: repo), token: token)
    }
    
    func isRepositoryStarred(owner: String, repo: String, token: String) async throws -> Bool {
        do {
            try await apiClient.requestNoContent(.checkStarred(owner: owner, repo: repo), token: token)
            return true
        } catch GitHubAPIError.notFound {
            return false
        }
    }
}
