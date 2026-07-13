//
//  ProfileView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    let username: String?
    @State private var viewModel: ProfileViewModel
    
    init(username: String? = nil, profileService: ProfileServiceProtocol, authManager: AuthManager) {
        self.username = username
        _viewModel = State(initialValue: ProfileViewModel(profileService: profileService, authManager: authManager))
    }
    
    var body: some View {
        content
            .task {
                if let username {
                    await viewModel.loadProfile(username: username)
                } else {
                    await viewModel.loadOwnProfile()
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded(let user):
            profileContent(user)
        case .failed(let message):
            Text(message)
                .foregroundStyle(.red)
        }
    }
    
    private func profileContent(_ user: User) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: user.avatarURL) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            Text(user.name ?? user.login)
                .font(.title2)
                .bold()
            
            Text("@\(user.login)")
                .foregroundStyle(.secondary)
            
            if let bio = user.bio {
                Text(bio)
            }
            
            HStack(spacing: 16) {
                Text("\(user.publicRepos) repos")
                Text("\(user.followers) followers")
                Text("\(user.following) following")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding()
    }
}
