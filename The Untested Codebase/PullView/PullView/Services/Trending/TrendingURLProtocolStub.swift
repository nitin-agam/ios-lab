//
//  TrendingURLProtocolStub.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

// Note: this is the exact same URLProtocol mechanism your testing articles (008 especially) will use later to stub network calls in actual XCTest/Swift Testing test targets. Building this feature this way now means Phase 8 doubles as a live, working preview of that testing technique before Article 008 formally teaches it — worth calling out explicitly in the article text.

extension URLSession {
    static let trendingStubbed: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [TrendingURLProtocolStub.self]
        return URLSession(configuration: config)
    }()
}

final class TrendingURLProtocolStub: URLProtocol {
    static let trendingURL = URL(string: "https://api.github.com/trending/repositories")!
    
    override class func canInit(with request: URLRequest) -> Bool {
        request.url == trendingURL
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let fixtureURL = Bundle.main.url(forResource: "trending_repositories", withExtension: "json") else {
            client?.urlProtocol(self, didFailWithError: GitHubAPIError.network("Missing trending fixture"))
            return
        }
        
        do {
            let data = try Data(contentsOf: fixtureURL)
            let response = HTTPURLResponse(url: Self.trendingURL, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // No-op: no ongoing task to cancel since data is loaded synchronously from the bundle.
    }
}
