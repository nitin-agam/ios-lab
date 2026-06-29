//
//  LoadingState.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

enum LoadingState<T> {
    case idle
    case loading
    case loaded(T)
    case error(String)
}
