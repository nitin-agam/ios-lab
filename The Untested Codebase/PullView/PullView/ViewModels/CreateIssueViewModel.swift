//
//  CreateIssueViewModel.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class CreateIssueViewModel {
    var title: String = ""
    var body: String = ""
    private(set) var isSubmitting = false
    private(set) var errorMessage: String?
    
    private let owner: String
    private let repo: String
    private let issueService: IssueServiceProtocol
    private let authManager: AuthManager
    
    init(owner: String, repo: String, issueService: IssueServiceProtocol, authManager: AuthManager) {
        self.owner = owner
        self.repo = repo
        self.issueService = issueService
        self.authManager = authManager
    }
    
    var canSubmit: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && !isSubmitting
    }
    
    func submit() async -> Issue? {
        guard let token = try? await authManager.currentToken() else {
            errorMessage = "Not signed in"
            return nil
        }
        
        isSubmitting = true
        errorMessage = nil
        
        do {
            let issue = try await issueService.createIssue(
                owner: owner,
                repo: repo,
                title: title,
                body: body.isEmpty ? nil : body,
                token: token
            )
            isSubmitting = false
            return issue
        } catch {
            errorMessage = "Couldn't create issue"
            isSubmitting = false
            return nil
        }
    }
}
