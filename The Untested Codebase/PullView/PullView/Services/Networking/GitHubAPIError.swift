//
//  GitHubAPIError.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

enum GitHubAPIError: Error, Equatable {
    case invalidURL
    case unauthorized
    case rateLimited
    case notFound
    case decodingFailed
    case network(String)
    case unknown(statusCode: Int)
}
