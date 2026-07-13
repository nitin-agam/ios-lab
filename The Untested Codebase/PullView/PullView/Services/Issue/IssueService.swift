//
//  IssueService.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

protocol IssueServiceProtocol {
    func fetchIssues(owner: String, repo: String, state: String, page: Int, token: String?) async throws -> [Issue]
    func createIssue(owner: String, repo: String, title: String, body: String?, token: String) async throws -> Issue
    func closeIssue(owner: String, repo: String, number: Int, token: String) async throws -> Issue
}

final class IssueService: IssueServiceProtocol {
    private let apiClient: GitHubAPIClientProtocol

    init(apiClient: GitHubAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchIssues(owner: String, repo: String, state: String, page: Int, token: String?) async throws -> [Issue] {
        try await apiClient.request(.issues(owner: owner, repo: repo, state: state, page: page), token: token)
    }

    func createIssue(owner: String, repo: String, title: String, body: String?, token: String) async throws -> Issue {
        let payload = CreateIssueRequest(title: title, body: body)
        return try await apiClient.request(.createIssue(owner: owner, repo: repo), body: payload, token: token)
    }

    func closeIssue(owner: String, repo: String, number: Int, token: String) async throws -> Issue {
        let payload = CloseIssueRequest(state: "closed")
        return try await apiClient.request(.closeIssue(owner: owner, repo: repo, number: number), body: payload, token: token)
    }
}
