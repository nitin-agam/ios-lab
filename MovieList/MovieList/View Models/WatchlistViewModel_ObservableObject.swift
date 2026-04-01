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
    @Published var searchText = ""
    @Published var selectedGenre: Movie.Genre?
    @Published var isFamilyMode = false
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

extension WatchlistViewModel_ObservableObject {
    
    var filteredMovies: [Movie] {
        movies
            .filter { selectedGenre == nil ? true : $0.genre == selectedGenre }
            .filter { searchText.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(searchText) }
            .filter { isFamilyMode ? $0.rating >= 7.0 : true }
            .sorted { !$0.isWatched && $1.isWatched }
    }
}
