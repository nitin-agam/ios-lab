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
    
    private enum Keys {
        static let displayName = "preferences.displayName"
        static let showRatings = "preferences.showRatings"
    }
    
    @Published var displayName: String {
        didSet {
            UserDefaults.standard.set(displayName, forKey: Keys.displayName)
        }
    }
    
    @Published var showRatings: Bool {
        didSet {
            UserDefaults.standard.set(showRatings, forKey: Keys.showRatings)
        }
    }
    
    init() {
        let defaults = UserDefaults.standard
        self.displayName = defaults.string(forKey: Keys.displayName) ?? "Swiftable"
        self.showRatings = defaults.object(forKey: Keys.showRatings) as? Bool ?? true
    }
}

// v2.0
@Observable
class UserPreferencesObservable {
    var displayName: String = "Swiftable"
    var showRatings: Bool = true
}
