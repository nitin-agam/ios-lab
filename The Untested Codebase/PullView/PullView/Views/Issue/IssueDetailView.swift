//
//  IssueDetailView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct IssueDetailView: View {
    
    @State private var issue: Issue
    let owner: String
    let repo: String
    let issueService: IssueServiceProtocol
    let authManager: AuthManager
    @State private var isClosing = false
    
    init(issue: Issue, owner: String, repo: String, issueService: IssueServiceProtocol, authManager: AuthManager) {
        _issue = State(initialValue: issue)
        self.owner = owner
        self.repo = repo
        self.issueService = issueService
        self.authManager = authManager
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(issue.title)
                    .font(.title2)
                    .bold()
                
                HStack(spacing: 8) {
                    Label(issue.state == .open ? "Open" : "Closed", systemImage: issue.state == .open ? "circle" : "checkmark.circle.fill")
                        .foregroundStyle(issue.state == .open ? .green : .purple)
                    Text("#\(issue.number) opened by \(issue.user.login)")
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
                
                if let body = issue.body, !body.isEmpty {
                    Text(body)
                } else {
                    Text("No description provided.")
                        .foregroundStyle(.secondary)
                        .italic()
                }
                
                Text("Updated \(issue.updatedAt.formatted(.relative(presentation: .named)))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                if issue.state == .open {
                    Button(role: .destructive) {
                        Task { await closeIssue() }
                    } label: {
                        if isClosing {
                            ProgressView()
                        } else {
                            Text("Close Issue")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isClosing)
                }
            }
            .padding()
        }
        .navigationTitle("#\(issue.number)")
    }
    
    private func closeIssue() async {
        guard let token = try? await authManager.currentToken() else { return }
        isClosing = true
        if let updated = try? await issueService.closeIssue(owner: owner, repo: repo, number: issue.number, token: token) {
            issue = updated
        }
        isClosing = false
    }
}
