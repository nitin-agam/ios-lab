//
//  SearchResult.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

struct SearchResult<T: Codable & Equatable>: Codable, Equatable {
    
    let totalCount: Int
    let incompleteResults: Bool
    let items: [T]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
