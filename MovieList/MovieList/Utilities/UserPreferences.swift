//
//  UserPreferences.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 29/03/26.
//

import SwiftUI
import Combine

// v1.0
class UserPreferencesObservableObject: ObservableObject {
    @Published var displayName: String = "Swiftable"
    @Published var showRatings: Bool = true
}

// v2.0
@Observable
class UserPreferencesObservable {
    var displayName: String = "Swiftable"
    var showRatings: Bool = true
}
