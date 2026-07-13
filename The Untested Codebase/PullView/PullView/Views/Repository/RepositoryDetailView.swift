//
//  RepositoryDetailView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct RepositoryDetailView: View {
    
    let repository: Repository
    let issueService: IssueServiceProtocol
    let repositoryService: RepositoryServiceProtocol
    let authManager: AuthManager
    @State private var isStarred = false
    @State private var isTogglingStar = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(repository.fullName)
                    .font(.title2)
                    .bold()
                
                if let description = repository.description {
                    Text(description)
                }
                
                HStack(spacing: 20) {
                    Label("\(repository.stargazersCount) stars", systemImage: "star")
                    Label("\(repository.forksCount) forks", systemImage: "tuningfork")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                if let language = repository.language {
                    Text("Language: \(language)")
                        .font(.subheadline)
                }
                
                Text("Updated \(repository.updatedAt.formatted(.relative(presentation: .named)))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Button {
                    Task { await toggleStar() }
                } label: {
                    if isTogglingStar {
                        ProgressView()
                    } else {
                        Label(isStarred ? "Starred" : "Star", systemImage: isStarred ? "star.fill" : "star")
                    }
                }
                .buttonStyle(.bordered)
                .disabled(isTogglingStar)
                
                NavigationLink {
                    IssueListView(owner: repository.owner.login, repo: repository.name, issueService: issueService, authManager: authManager)
                } label: {
                    Label("View Issues", systemImage: "exclamationmark.circle")
                }
            }
            .padding()
        }
        .navigationTitle(repository.name)
        .task {
            await loadStarStatus()
        }
    }
    
    private func loadStarStatus() async {
        guard let token = try? await authManager.currentToken() else { return }
        isStarred = (try? await repositoryService.isRepositoryStarred(owner: repository.owner.login, repo: repository.name, token: token)) ?? false
    }
    
    private func toggleStar() async {
        guard let token = try? await authManager.currentToken() else { return }
        isTogglingStar = true
        do {
            if isStarred {
                try await repositoryService.unstarRepository(owner: repository.owner.login, repo: repository.name, token: token)
            } else {
                try await repositoryService.starRepository(owner: repository.owner.login, repo: repository.name, token: token)
            }
            isStarred.toggle()
        } catch {
            // Star toggle failure is non-critical to the viewing flow — leave state unchanged, no user-facing error for now
        }
        isTogglingStar = false
    }
}
