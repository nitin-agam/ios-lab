//
//  PullViewApp.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct PullViewApp: App {
    
    @State private var environment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(environment)
        }
        .modelContainer(for: [RecentSearch.self, CachedRepository.self])
    }
}
