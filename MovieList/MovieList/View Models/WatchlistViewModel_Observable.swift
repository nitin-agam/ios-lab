//
//  WatchlistViewModel_Observable.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 29/03/26.
//

import Foundation

@Observable
class WatchlistViewModel_Observable {
    
    // No @Published needed as @Observable macro handles observation for every stored property automatically, at the property level
    var movies: [Movie] = []
    var isLoading = false
    var errorMessage: String?
    
    // computed properties work exactly the same
    var watchedCount: Int {
        movies.filter { $0.isWatched }.count
    }
    
    var totalCount: Int {
        movies.count
    }
    
    func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            movies = try await MovieService.shared.fetchWatchlist()
        } catch {
            errorMessage = "Failed to load movies. Please try again."
        }
    }
    
    func markAsWatched(_ movie: Movie) {
        guard let index = movies.firstIndex(where: { $0.id == movie.id }) else { return }
        movies[index].isWatched = true
    }
    
    func removeFromWatchlist(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
    }
}
