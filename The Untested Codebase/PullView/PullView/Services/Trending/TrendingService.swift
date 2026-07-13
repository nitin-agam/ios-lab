//
//  TrendingService.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

// Note: this deliberately bypasses GitHubAPIClient entirely, rather than routing through it. GitHubAPIClient exists to talk to the real GitHub REST API with real auth, real error codes, real pagination — none of which apply here. TrendingService is its own small, self-contained thing that happens to look similar. Forcing it through the same client just to reuse code would blur a distinction that's actually important: this feature has no real backend.

protocol TrendingServiceProtocol {
    func fetchTrendingRepositories() async throws -> [Repository]
}

final class TrendingService: TrendingServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .trendingStubbed) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func fetchTrendingRepositories() async throws -> [Repository] {
        var request = URLRequest(url: TrendingURLProtocolStub.trendingURL)
        request.httpMethod = "GET"
        
        let (data, _) = try await session.data(for: request)
        return try decoder.decode([Repository].self, from: data)
    }
}
