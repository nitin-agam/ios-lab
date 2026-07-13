//
//  TrendingRepositoriesViewModel.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class TrendingRepositoriesViewModel {
    private(set) var state: LoadingState<[Repository]> = .idle
    
    private let trendingService: TrendingServiceProtocol
    
    init(trendingService: TrendingServiceProtocol) {
        self.trendingService = trendingService
    }
    
    func load() async {
        state = .loading
        do {
            let repos = try await trendingService.fetchTrendingRepositories()
            state = .loaded(repos)
        } catch {
            state = .failed("Couldn't load trending repositories: \(error)")
        }
    }
}
