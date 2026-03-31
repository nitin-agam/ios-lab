//
//  MovieDetailView_Observable.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 29/03/26.
//

import SwiftUI

struct MovieDetailView_Observable: View {
    
    let movie: Movie
    
    // No @ObservedObject needed, @Observable handles observation automatically
    // SwiftUI tracks exactly which properties this view reads, and only re-renders when those specific properties change
    var viewModel: WatchlistViewModel_Observable
    
    // @Environment with type replaces @EnvironmentObject
    @Environment(UserPreferencesObservable.self) private var preferences
    
    @State private var showRemoveAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                metaSection
                synopsisSection
                actionSection
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.large)
        .alert("Remove from Watchlist?", isPresented: $showRemoveAlert) {
            Button("Remove", role: .destructive) {
                viewModel.removeFromWatchlist(movie)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove \"\(movie.title)\" from your watchlist.")
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(genreColor.opacity(0.15))
                    .frame(width: 64, height: 64)
                Image(systemName: movie.genre.icon)
                    .font(.system(size: 28))
                    .foregroundColor(genreColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.genre.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(genreColor)
                    .tracking(1.2)
                
                if preferences.showRatings {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.subheadline)
                        Text(String(format: "%.1f", movie.rating))
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("/ 10")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            
            Spacer()
            
            if movie.isWatched {
                VStack(spacing: 2) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    Text("Watched")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
        }
    }
    
    private var metaSection: some View {
        HStack(spacing: 0) {
            metaItem(icon: "calendar", label: "Year", value: String(movie.year))
            Divider().frame(height: 36)
            metaItem(icon: "clock", label: "Duration", value: formattedDuration)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var synopsisSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Synopsis")
                .font(.headline)
            Text(movie.synopsis)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
    
    private var actionSection: some View {
        VStack(spacing: 12) {
            if !movie.isWatched {
                Button {
                    viewModel.markAsWatched(movie)
                } label: {
                    Label("Mark as Watched", systemImage: "checkmark.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .font(.headline)
                }
            }
            
            Button(role: .destructive) {
                showRemoveAlert = true
            } label: {
                Label("Remove from Watchlist", systemImage: "trash")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(.red)
                    .cornerRadius(12)
                    .font(.headline)
            }
        }
    }
    
    private func metaItem(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var formattedDuration: String {
        let hours = movie.duration / 60
        let minutes = movie.duration % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
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
