//
//  GitHubEndpoint.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

enum GitHubEndpoint {
    
    case userProfile(username: String)
    case authenticatedUser
    case repositories(username: String, page: Int)
    case repositoryDetail(owner: String, repo: String)
    case searchRepositories(query: String, page: Int)
    case searchUsers(query: String, page: Int)
    case issues(owner: String, repo: String, state: String, page: Int)
    case createIssue(owner: String, repo: String)
    case closeIssue(owner: String, repo: String, number: Int)
    case starredRepositories(page: Int)
    case checkStarred(owner: String, repo: String)
    case starRepository(owner: String, repo: String)
    case unstarRepository(owner: String, repo: String)
    
    var path: String {
        switch self {
        case .userProfile(let username):
            return "/users/\(username)"
        case .authenticatedUser:
            return "/user"
        case .repositories(let username, _):
            return "/users/\(username)/repos"
        case .repositoryDetail(let owner, let repo):
            return "/repos/\(owner)/\(repo)"
        case .searchRepositories:
            return "/search/repositories"
        case .searchUsers:
            return "/search/users"
        case .issues(let owner, let repo, _, _):
            return "/repos/\(owner)/\(repo)/issues"
        case .createIssue(let owner, let repo):
            return "/repos/\(owner)/\(repo)/issues"
        case .closeIssue(let owner, let repo, let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)"
        case .starredRepositories:
            return "/user/starred"
        case .checkStarred(let owner, let repo), .starRepository(let owner, let repo), .unstarRepository(let owner, let repo):
            return "/user/starred/\(owner)/\(repo)"
        }
    }
    
    var method: String {
        switch self {
        case .createIssue:
            return "POST"
        case .starRepository:
            return "PUT"
        case .closeIssue:
            return "PATCH"
        case .unstarRepository:
            return "DELETE"
        default:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .repositories(_, let page), .starredRepositories(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .searchRepositories(let query, let page), .searchUsers(let query, let page):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .issues(_, _, let state, let page):
            return [
                URLQueryItem(name: "state", value: state),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        default:
            return nil
        }
    }
}
