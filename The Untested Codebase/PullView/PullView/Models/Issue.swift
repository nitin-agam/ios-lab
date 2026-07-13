//
//  Issue.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

struct Issue: Codable, Identifiable, Equatable, Hashable {
    
    let id: Int
    let number: Int
    let title: String
    let body: String?
    let state: State
    let user: RepositoryOwner
    let createdAt: Date
    let updatedAt: Date
    let closedAt: Date?

    enum State: String, Codable {
        case open
        case closed
    }

    enum CodingKeys: String, CodingKey {
        case id, number, title, body, state, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
    }
}

struct CreateIssueRequest: Encodable {
    let title: String
    let body: String?
}

struct CloseIssueRequest: Encodable {
    let state: String
}
