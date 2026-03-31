//
//  WatchlistView_ObservableObject.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 19/03/26.
//

import SwiftUI

struct WatchlistView_ObservableObject: View {
    
    @StateObject private var viewModel = WatchlistViewModel_ObservableObject()
    @EnvironmentObject private var preferences: UserPreferencesObservableObject
    
    @State private var searchText = ""
    @State private var selectedGenre: Movie.Genre? = nil
    @State private var showOnlyWatched = false
    @State private var showSettings = false
    
    private var navigationTitle: String {
        preferences.displayName.isEmpty ? "My Watchlist" : "\(preferences.displayName)'s Watchlist"
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.errorMessage {
                    errorView(message: error)
                } else if viewModel.movies.isEmpty {
                    emptyView
                } else {
                    movieListView
                }
            }
            .navigationTitle(navigationTitle)
            .toolbar { filterToolbar }
        }
        .sheet(isPresented: $showSettings) {
            SettingsSheetView()
        }
        .task {
            // fetch only if not already loaded
            if viewModel.movies.isEmpty {
                await viewModel.fetchMovies()
            }
        }
    }
    
    private var movieListView: some View {
        VStack(spacing: 0) {
            progressBanner
            FilterBarView(
                selectedGenre: $selectedGenre,
                showOnlyWatched: $showOnlyWatched
            )
            
            List {
                ForEach(filteredMovies) { movie in
                    NavigationLink(
                        destination: MovieDetailView_ObservableObject(
                            movie: movie,
                            viewModel: viewModel
                        )
                    ) {
                        MovieRowView(movie: movie)
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Search movies...")
            .animation(.default, value: filteredMovies.map { $0.id })
        }
    }
    
    private var progressBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Your Progress")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(viewModel.watchedCount) of \(viewModel.totalCount) watched")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            Spacer()
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(width: 100, height: 8)
                Capsule()
                    .fill(Color.accentColor)
                    .frame(
                        width: viewModel.totalCount > 0
                        ? CGFloat(viewModel.watchedCount) / CGFloat(viewModel.totalCount) * 100
                        : 0,
                        height: 8
                    )
                    .animation(.easeInOut, value: viewModel.watchedCount)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
    }
    
    @ToolbarContentBuilder
    private var filterToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView().scaleEffect(1.3)
            Text("Loading your watchlist...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundColor(.orange)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Button("Try Again") {
                Task { await viewModel.fetchMovies() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.stack")
                .font(.system(size: 44))
                .foregroundColor(.secondary)
            Text("No movies found")
                .font(.headline)
            Text("Try adjusting your filters or search term.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var filteredMovies: [Movie] {
        viewModel.movies
            .filter { showOnlyWatched ? $0.isWatched : true }
            .filter { selectedGenre == nil ? true : $0.genre == selectedGenre }
            .filter {
                searchText.isEmpty
                ? true
                : $0.title.localizedCaseInsensitiveContains(searchText)
            }
    }
}
