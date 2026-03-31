//
//  MovieListApp.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 19/03/26.
//

import SwiftUI

@main
struct MovieListApp: App {
    
    @StateObject private var preferences = UserPreferencesObservableObject()
    
    var body: some Scene {
        WindowGroup {
            WatchlistView_ObservableObject()
                .environmentObject(preferences)
        }
    }
}

// This is iOS 17+ equivalent entry point to use @Observable.
// Use @main to this struct instead of MovieListApp to get it working.
struct MovieListApp_Observable: App {
    
    @State private var preferences = UserPreferencesObservable()
    
    var body: some Scene {
        WindowGroup {
            WatchlistView_Observable()
                .environment(preferences)
        }
    }
}
