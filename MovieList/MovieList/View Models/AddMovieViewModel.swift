//
//  AddMovieViewModel.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 20/04/26.
//

import SwiftUI
import Combine

@MainActor
class AddMovieViewModel: ObservableObject {

    @Published var form = AddMovieForm()
    @Published var currentStep: AddMovieStep = .details

    func goToConfirmation() {
        guard form.isStepOneValid else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = .confirm
        }
    }

    func goBackToDetails() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = .details
        }
    }

    func submitMovie(to watchlist: WatchlistViewModel_ObservableObject) {
        let newMovie = Movie(
            id: UUID(),
            title: form.title.trimmingCharacters(in: .whitespaces),
            genre: form.genre ?? .drama,
            rating: Double(form.rating) ?? 0.0,
            year: Int(form.year) ?? Calendar.current.component(.year, from: Date()),
            synopsis: form.synopsis.trimmingCharacters(in: .whitespaces),
            duration: Int(form.duration) ?? 0,
            isWatched: false
        )
        watchlist.addMovie(newMovie)
    }

    func reset() {
        form = AddMovieForm()
        currentStep = .details
    }
}
