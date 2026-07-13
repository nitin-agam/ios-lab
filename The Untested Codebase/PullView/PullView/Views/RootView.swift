//
//  RootView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @Environment(AppEnvironment.self) private var environment
    
    var body: some View {
        Group {
            switch environment.authState {
            case .signedOut:
                LoginView()
            case .signedIn(let username):
                TabView {
                    NavigationStack {
                        RepositoryListView(username: username, repositoryService: environment.repositoryService, authManager: environment.authManager)
                            .navigationDestination(for: Repository.self) { repo in
                                RepositoryDetailView(repository: repo, issueService: environment.issueService, repositoryService: environment.repositoryService, authManager: environment.authManager)
                            }
                            .navigationTitle("Repositories")
                    }
                    .tabItem { Label("Repos", systemImage: "folder") }
                    
                    SearchView(searchService: environment.searchService, authManager: environment.authManager)
                        .tabItem { Label("Search", systemImage: "magnifyingglass") }
                    
                    StarredRepositoriesView(repositoryService: environment.repositoryService, issueService: environment.issueService, authManager: environment.authManager)
                        .tabItem { Label("Starred", systemImage: "star") }
                    
                    TrendingRepositoriesView(trendingService: environment.trendingService, repositoryService: environment.repositoryService, issueService: environment.issueService, authManager: environment.authManager)
                        .tabItem { Label("Trending", systemImage: "flame") }
                    
                    AccountView()
                        .tabItem { Label("Account", systemImage: "person.circle") }
                }
            }
        }
        .task {
            await environment.restoreSession()
        }
    }
}

#Preview {
    RootView()
        .environment(AppEnvironment())
}
