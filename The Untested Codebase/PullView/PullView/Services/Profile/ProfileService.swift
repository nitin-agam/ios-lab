//
//  ProfileService.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchOwnProfile(token: String) async throws -> User
    func fetchProfile(username: String, token: String?) async throws -> User
}

final class ProfileService: ProfileServiceProtocol {
    
    private let apiClient: GitHubAPIClientProtocol

    init(apiClient: GitHubAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchOwnProfile(token: String) async throws -> User {
        try await apiClient.request(.authenticatedUser, token: token)
    }

    func fetchProfile(username: String, token: String?) async throws -> User {
        try await apiClient.request(.userProfile(username: username), token: token)
    }
}
