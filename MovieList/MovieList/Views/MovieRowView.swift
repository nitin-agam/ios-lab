//
//  MovieRowView.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 19/03/26.
//

import SwiftUI

struct MovieRowView: View {
    
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            genreIcon
            movieInfo
            Spacer()
            trailingInfo
        }
        .padding(.vertical, 4)
    }

    private var genreIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(genreColor.opacity(0.15))
                .frame(width: 44, height: 44)

            Image(systemName: movie.genre.icon)
                .foregroundColor(genreColor)
                .font(.system(size: 18))
        }
    }

    private var movieInfo: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(movie.title)
                .font(.headline)
                .foregroundColor(movie.isWatched ? .secondary : .primary)

            HStack(spacing: 6) {
                Text(movie.genre.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("•")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(String(movie.year))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var trailingInfo: some View {
        VStack(alignment: .trailing, spacing: 4) {
            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", movie.rating))
                    .font(.caption)
                    .fontWeight(.medium)
            }

            if movie.isWatched {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
    }

    private var genreColor: Color {
        switch movie.genre {
        case .action:   return .red
        case .drama:    return .purple
        case .thriller: return .orange
        case .scifi:    return .blue
        case .comedy:   return .yellow
        }
    }
}
