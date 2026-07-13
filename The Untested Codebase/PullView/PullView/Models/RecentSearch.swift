//
//  RecentSearch.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class RecentSearch {
    
    var query: String
    var scope: String
    var timestamp: Date

    init(query: String, scope: String, timestamp: Date = .now) {
        self.query = query
        self.scope = scope
        self.timestamp = timestamp
    }
}
