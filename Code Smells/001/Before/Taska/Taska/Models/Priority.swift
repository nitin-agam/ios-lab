//
//  Priority.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

enum Priority: String, CaseIterable, Codable, Identifiable {
    
    case high
    case medium
    case low

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}
