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
        
        clearDraft()
    }

    func reset() {
        form = AddMovieForm()
        currentStep = .details
        clearDraft()
    }
}

extension AddMovieViewModel {

    private enum Keys {
        static let draft = "addMovie.draft"
    }

    func saveDraft() {
        // don't save empty drafts
        guard hasMeaningfulContent else {
            clearDraft()
            return
        }

        do {
            let data = try JSONEncoder().encode(form)
            UserDefaults.standard.set(data, forKey: Keys.draft)
        } catch {
            print("Failed to encode AddMovieForm draft: \(error)")
        }
    }

    func restoreDraft() {
        guard let data = UserDefaults.standard.data(forKey: Keys.draft) else { return }

        do {
            form = try JSONDecoder().decode(AddMovieForm.self, from: data)
        } catch {
            // stored draft is corrupt or schema changed; clear and move on
            clearDraft()
        }
    }

    func clearDraft() {
        UserDefaults.standard.removeObject(forKey: Keys.draft)
    }

    private var hasMeaningfulContent: Bool {
        !form.title.isEmpty || !form.synopsis.isEmpty ||
        !form.year.isEmpty || !form.rating.isEmpty ||
        !form.duration.isEmpty || form.genre != nil
    }
}
