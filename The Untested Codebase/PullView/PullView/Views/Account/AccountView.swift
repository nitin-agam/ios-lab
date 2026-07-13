//
//  AccountView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(AppEnvironment.self) private var environment
    @State private var isSigningOut = false
    
    var body: some View {
        NavigationStack {
            List {
                if case .signedIn(let username) = environment.authState {
                    Section {
                        Text("Signed in as \(username)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        Task { await signOut() }
                    } label: {
                        if isSigningOut {
                            ProgressView()
                        } else {
                            Text("Sign Out")
                        }
                    }
                    .disabled(isSigningOut)
                }
            }
            .navigationTitle("Account")
        }
    }
    
    private func signOut() async {
        isSigningOut = true
        try? await environment.signOut()
        isSigningOut = false
    }
}
