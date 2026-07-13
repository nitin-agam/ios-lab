//
//  StarredRepositoryCache.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import SwiftData

protocol StarredRepositoryCacheProtocol {
    func save(_ repositories: [Repository]) throws
    func fetchAll() throws -> [Repository]
    func remove(id: Int) throws
    func clear() throws
}

final class StarredRepositoryCache: StarredRepositoryCacheProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save(_ repositories: [Repository]) throws {
        for repo in repositories {
            let cached = CachedRepository(from: repo)
            modelContext.insert(cached)
        }
        try modelContext.save()
    }
    
    func fetchAll() throws -> [Repository] {
        let descriptor = FetchDescriptor<CachedRepository>(
            sortBy: [SortDescriptor(\.cachedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map { $0.toRepository() }
    }
    
    func remove(id: Int) throws {
        let descriptor = FetchDescriptor<CachedRepository>(
            predicate: #Predicate { $0.id == id }
        )
        if let match = try modelContext.fetch(descriptor).first {
            modelContext.delete(match)
            try modelContext.save()
        }
    }
    
    func clear() throws {
        try modelContext.delete(model: CachedRepository.self)
    }
}

// Note: save doesn't check for existing entries before inserting — calling it twice with overlapping repos will create duplicate rows despite @Attribute(.unique) var id. SwiftData's .unique constraint should actually prevent true duplicates at the database level and instead upsert, but this is exactly the kind of behavior worth verifying by testing rather than assuming — if you see duplicate rows in practice, the fix is to fetch-then-update-or-insert per item rather than blind inserts, which we can add if it comes up.

