//
//  MovieListApp.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 19/03/26.
//

import SwiftUI

@main
struct MovieListApp: App {
    
    @State private var preferences = UserPreferencesObservableObject()
    
    var body: some Scene {
        WindowGroup {
            WatchlistView_ObservableObject()
                .environmentObject(preferences)
        }
    }
}
