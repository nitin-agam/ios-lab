//
//  FilterBarView.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 29/03/26.
//

import SwiftUI

struct FilterBarView: View {
    
    @Binding var selectedGenre: Movie.Genre?
    @Binding var showOnlyWatched: Bool

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.maxGenreChips) private var maxGenreChips

    private var visibleGenres: [Movie.Genre] {
        Array(Movie.Genre.allCases.prefix(maxGenreChips))
    }

    var body: some View {
        VStack(spacing: 0) {
            genreScroll
            watchedToggleRow
        }
        .background(Color(.systemBackground))
    }

    private var genreScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(label: "All", isSelected: selectedGenre == nil) {
                    selectedGenre = nil
                }
                ForEach(visibleGenres, id: \.self) { genre in
                    chip(label: genre.rawValue, isSelected: selectedGenre == genre) {
                        selectedGenre = selectedGenre == genre ? nil : genre
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    private func chip(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }

    private var watchedToggleRow: some View {
        Toggle(isOn: $showOnlyWatched) {
            Label("Show watched only", systemImage: "checkmark.circle")
                .font(.subheadline)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .tint(.green)
    }
}
