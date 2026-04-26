//
//  Movie.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 19/03/26.
//

import Foundation

struct Movie: Identifiable, Codable {
    
    let id: UUID
    let title: String
    let genre: Genre
    let rating: Double
    let year: Int
    let synopsis: String
    let duration: Int
    var isWatched: Bool

    enum Genre: String, Codable, CaseIterable {
        case action   = "Action"
        case drama    = "Drama"
        case thriller = "Thriller"
        case scifi    = "Sci-Fi"
        case comedy   = "Comedy"

        var icon: String {
            switch self {
            case .action:   return "flame.fill"
            case .drama:    return "theatermasks.fill"
            case .thriller: return "eye.trianglebadge.exclamationmark.fill"
            case .scifi:    return "sparkles"
            case .comedy:   return "face.smiling.fill"
            }
        }
    }
}
