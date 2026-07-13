//
//  Repository.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

struct Repository: Codable, Identifiable, Equatable, Hashable {
    
    let id: Int
    let name: String
    let fullName: String
    let owner: RepositoryOwner
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let language: String?
    let htmlURL: URL
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, name, owner, description, language
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case htmlURL = "html_url"
        case updatedAt = "updated_at"
    }
}
