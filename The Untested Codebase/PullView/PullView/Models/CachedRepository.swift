//
//  CachedRepository.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import SwiftData

// Why not store Repository directly? SwiftData @Model requires a reference type with its own storage schema - you can't just persist your existing Codable struct as-is. So CachedRepository duplicates the fields, and toRepository() reconstructs a Repository value for the UI layer to consume, keeping SwiftData an implementation detail the rest of the app doesn't need to know about.

@Model
final class CachedRepository {
    
    @Attribute(.unique) var id: Int
    var name: String
    var fullName: String
    var ownerLogin: String
    var ownerAvatarURL: URL
    var repoDescription: String?
    var stargazersCount: Int
    var forksCount: Int
    var language: String?
    var htmlURL: URL
    var updatedAt: Date
    var cachedAt: Date

    init(from repository: Repository, cachedAt: Date = .now) {
        self.id = repository.id
        self.name = repository.name
        self.fullName = repository.fullName
        self.ownerLogin = repository.owner.login
        self.ownerAvatarURL = repository.owner.avatarURL
        self.repoDescription = repository.description
        self.stargazersCount = repository.stargazersCount
        self.forksCount = repository.forksCount
        self.language = repository.language
        self.htmlURL = repository.htmlURL
        self.updatedAt = repository.updatedAt
        self.cachedAt = cachedAt
    }

    func toRepository() -> Repository {
        Repository(
            id: id,
            name: name,
            fullName: fullName,
            owner: RepositoryOwner(id: 0, login: ownerLogin, avatarURL: ownerAvatarURL, htmlURL: htmlURL),
            description: repoDescription,
            stargazersCount: stargazersCount,
            forksCount: forksCount,
            language: language,
            htmlURL: htmlURL,
            updatedAt: updatedAt
        )
    }
}

// Why RepositoryOwner(id: 0, ...)? You're not caching the owner's numeric ID separately, only login and avatarURL (all the UI actually renders). Using 0 as a placeholder is a real limitation worth calling out in the article rather than hiding - if RepositoryOwner.id were ever used for anything beyond satisfying Identifiable/Hashable, this would be a bug. It isn't currently, but it's exactly the kind of shortcut that becomes a landmine if someone extends the model later without reading this comment.
