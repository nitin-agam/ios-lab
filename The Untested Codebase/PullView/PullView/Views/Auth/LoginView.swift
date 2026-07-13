//
//  LoginView.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AppEnvironment.self) private var environment
    @State private var token: String = ""
    @State private var isSigningIn = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Sign in to PullView")
                .font(.title2)
                .bold()
            
            SecureField("Personal Access Token", text: $token)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            
            Button {
                signIn()
            } label: {
                if isSigningIn {
                    ProgressView()
                } else {
                    Text("Sign In")
                }
            }
            .disabled(token.isEmpty || isSigningIn)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func signIn() {
        errorMessage = nil
        isSigningIn = true
        
        Task {
            do {
                try await environment.signIn(withToken: token)
            } catch {
                errorMessage = "Sign in failed. Check your token and try again."
            }
            isSigningIn = false
        }
    }
}

#Preview {
    LoginView()
        .environment(AppEnvironment())
}
