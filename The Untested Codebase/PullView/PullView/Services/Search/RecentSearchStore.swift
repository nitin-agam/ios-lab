//
//  RecentSearchStore.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import SwiftData

protocol RecentSearchStoreProtocol {
    func save(query: String, scope: String) throws
    func fetchRecent(limit: Int) throws -> [RecentSearch]
    func clear() throws
}

final class RecentSearchStore: RecentSearchStoreProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save(query: String, scope: String) throws {
        let entry = RecentSearch(query: query, scope: scope)
        modelContext.insert(entry)
        try modelContext.save()
    }
    
    func fetchRecent(limit: Int) throws -> [RecentSearch] {
        var descriptor = FetchDescriptor<RecentSearch>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try modelContext.fetch(descriptor)
    }
    
    func clear() throws {
        try modelContext.delete(model: RecentSearch.self)
    }
}
