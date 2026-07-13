//
//  Pagination.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

struct Paginated<Value: Equatable>: Equatable {
    var items: [Value]
    var currentPage: Int
    var hasMorePages: Bool
}
