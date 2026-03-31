//
//  WatchlistViewModel_ObservableObject.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 19/03/26.
//

import SwiftUI
import Combine

@MainActor
class WatchlistViewModel_ObservableObject: ObservableObject {

    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

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
