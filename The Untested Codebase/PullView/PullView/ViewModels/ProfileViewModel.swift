//
//  ProfileViewModel.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class ProfileViewModel {
    
    private(set) var state: LoadingState<User> = .idle
    
    private let profileService: ProfileServiceProtocol
    private let authManager: AuthManager
    
    init(profileService: ProfileServiceProtocol, authManager: AuthManager) {
        self.profileService = profileService
        self.authManager = authManager
    }
    
    func loadOwnProfile() async {
        state = .loading
        do {
            guard let token = try await authManager.currentToken() else {
                state = .failed("Not signed in")
                return
            }
            let user = try await profileService.fetchOwnProfile(token: token)
            state = .loaded(user)
        } catch {
            state = .failed("Couldn't load profile")
        }
    }
    
    func loadProfile(username: String) async {
        state = .loading
        do {
            let token = try? await authManager.currentToken()
            let user = try await profileService.fetchProfile(username: username, token: token ?? nil)
            state = .loaded(user)
        } catch {
            state = .failed("Couldn't load profile for \(username)")
        }
    }
}
