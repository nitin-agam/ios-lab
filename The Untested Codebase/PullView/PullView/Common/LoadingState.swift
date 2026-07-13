//
//  LoadingState.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

enum LoadingState<Value>: Equatable where Value: Equatable {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}
