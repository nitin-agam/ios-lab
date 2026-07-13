//
//  AuthManager.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

enum AuthState: Equatable {
    case signedOut
    case signedIn(username: String)
}

actor AuthManager {
    
    private let apiClient: GitHubAPIClientProtocol
    private let keychainStore: KeychainStoreProtocol
    private(set) var state: AuthState = .signedOut

    init(apiClient: GitHubAPIClientProtocol, keychainStore: KeychainStoreProtocol) {
        self.apiClient = apiClient
        self.keychainStore = keychainStore
    }

    func restoreSession() async {
        guard let token = try? keychainStore.readToken() else {
            state = .signedOut
            return
        }

        do {
            let user: User = try await apiClient.request(.authenticatedUser, token: token)
            state = .signedIn(username: user.login)
        } catch {
            state = .signedOut
        }
    }

    func signIn(withToken token: String) async throws {
        let user: User = try await apiClient.request(.authenticatedUser, token: token)
        try keychainStore.saveToken(token)
        state = .signedIn(username: user.login)
    }

    func signOut() throws {
        try keychainStore.deleteToken()
        state = .signedOut
    }

    func currentToken() throws -> String? {
        try keychainStore.readToken()
    }
}
