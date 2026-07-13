//
//  AppEnvironment.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class AppEnvironment {
    
    let apiClient: GitHubAPIClientProtocol
    let keychainStore: KeychainStoreProtocol
    let authManager: AuthManager
    let profileService: ProfileServiceProtocol
    let repositoryService: RepositoryServiceProtocol
    let searchService: SearchServiceProtocol
    let issueService: IssueServiceProtocol
    let trendingService: TrendingServiceProtocol
    var authState: AuthState = .signedOut
    
    init(apiClient: GitHubAPIClientProtocol? = nil,
         keychainStore: KeychainStoreProtocol? = nil) {
        
        let resolvedAPIClient = apiClient ?? GitHubAPIClient()
        let resolvedKeychainStore = keychainStore ?? KeychainStore()
        
        self.apiClient = resolvedAPIClient
        self.keychainStore = resolvedKeychainStore
        self.authManager = AuthManager(apiClient: resolvedAPIClient, keychainStore: resolvedKeychainStore)
        self.profileService = ProfileService(apiClient: resolvedAPIClient)
        self.repositoryService = RepositoryService(apiClient: resolvedAPIClient)
        self.searchService = SearchService(apiClient: resolvedAPIClient)
        self.issueService = IssueService(apiClient: resolvedAPIClient)
        self.trendingService = TrendingService()
    }
    
    func restoreSession() async {
        await authManager.restoreSession()
        authState = await authManager.state
    }
    
    func signIn(withToken token: String) async throws {
        try await authManager.signIn(withToken: token)
        authState = await authManager.state
    }
    
    func signOut() async throws {
        try await authManager.signOut()
        authState = .signedOut
    }
}
