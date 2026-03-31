//
//  MovieService.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 19/03/26.
//

import Foundation

// simulates a real async API call with a small artificial delay
struct MovieService {
    
    static let shared = MovieService()
    private init() {}
    
    func fetchWatchlist() async throws -> [Movie] {
        // simulate network latency
        try await Task.sleep(nanoseconds: 1_200_000_000) // 1.2 seconds
        return mockMovies
    }
    
    private let mockMovies: [Movie] = [
        Movie(id: UUID(),
              title: "Oppenheimer",
              genre: .drama,
              rating: 8.9,
              year: 2023,
              synopsis: "The story of J. Robert Oppenheimer's role in the development of the atomic bomb during World War II, and the political aftermath that followed.",
              duration: 180,
              isWatched: false),
        Movie(id: UUID(),
              title: "Dune: Part Two",
              genre: .scifi,
              rating: 8.6,
              year: 2024,
              synopsis: "Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.",
              duration: 166,
              isWatched: true),
        Movie(id: UUID(),
              title: "The Dark Knight",
              genre: .action,
              rating: 9.0,
              year: 2008,
              synopsis: "Batman faces the Joker, a criminal mastermind who plunges Gotham City into anarchy and forces Batman to question everything he believes.",
              duration: 152,
              isWatched: true),
        Movie(id: UUID(),
              title: "Parasite",
              genre: .thriller,
              rating: 8.5,
              year: 2019,
              synopsis: "A poor family schemes to become employed by a wealthy family by infiltrating their household and posing as unrelated, highly qualified individuals.",
              duration: 132,
              isWatched: false),
        Movie(id: UUID(),
              title: "Interstellar",
              genre: .scifi,
              rating: 8.7,
              year: 2014,
              synopsis: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival as Earth faces an environmental catastrophe.",
              duration: 169,
              isWatched: false),
        Movie(id: UUID(),
              title: "The Holdovers",
              genre: .drama,
              rating: 7.9,
              year: 2023,
              synopsis: "A curmudgeonly instructor at a New England prep school is forced to remain on campus over the holidays with a troubled student who has no place to go.",
              duration: 133,
              isWatched: false),
        Movie(id: UUID(),
              title: "Mad Max: Fury Road",
              genre: .action,
              rating: 8.1,
              year: 2015,
              synopsis: "In a post-apocalyptic wasteland, a woman rebels against a tyrannical ruler in search of her homeland with the help of a group of female prisoners.",
              duration: 120,
              isWatched: true),
        Movie(id: UUID(),
              title: "Knives Out",
              genre: .thriller,
              rating: 7.9,
              year: 2019,
              synopsis: "A detective investigates the death of a patriarch of an eccentric, combative family. A clever whodunit that keeps you guessing until the final frame.",
              duration: 130,
              isWatched: false),
        Movie(id: UUID(),
              title: "The Grand Budapest Hotel",
              genre: .comedy,
              rating: 8.1,
              year: 2014,
              synopsis: "A writer encounters the owner of an aging European hotel between the wars, who tells him of his early years serving as a lobby boy.",
              duration: 99,
              isWatched: true),
        Movie(id: UUID(),
              title: "Arrival",
              genre: .scifi,
              rating: 7.9,
              year: 2016,
              synopsis: "A linguist works with the military to communicate with alien lifeforms after twelve mysterious spacecraft appear around the world.",
              duration: 116,
              isWatched: false)
    ]
}
