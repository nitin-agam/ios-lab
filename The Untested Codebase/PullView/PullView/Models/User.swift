//
//  User.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable, Equatable, Hashable {
    
    let id: Int
    let login: String
    let name: String?
    let avatarURL: URL
    let bio: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
    let htmlURL: URL

    enum CodingKeys: String, CodingKey {
        case id, login, name, bio, followers, following
        case avatarURL = "avatar_url"
        case publicRepos = "public_repos"
        case htmlURL = "html_url"
    }
}

struct RepositoryOwner: Codable, Identifiable, Equatable, Hashable {
    
    let id: Int
    let login: String
    let avatarURL: URL
    let htmlURL: URL

    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}
