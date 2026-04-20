//
//  AddMovieForm.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 20/04/26.
//

import Foundation

enum AddMovieStep {
    case details
    case confirm
}

struct AddMovieForm {

    var title = ""
    var synopsis = ""
    var year = ""
    var rating = ""
    var genre: Movie.Genre?
    var duration = ""

    var touchedFields: Set<Field> = []

    enum Field {
        case title, year, rating, duration, genre
    }

    mutating func markTouched(_ field: Field) {
        touchedFields.insert(field)
    }

    func isTouched(_ field: Field) -> Bool {
        touchedFields.contains(field)
    }
}

// Validation
extension AddMovieForm {
    var isTitleValid: Bool {
        title.trimmingCharacters(in: .whitespaces).count >= 2
    }

    var isYearValid: Bool {
        guard let yearInt = Int(year) else { return false }
        let currentYear = Calendar.current.component(.year, from: Date())
        return yearInt >= 1888 && yearInt <= currentYear
    }

    var isRatingValid: Bool {
        guard let ratingDouble = Double(rating) else { return false }
        return (0.0...10.0).contains(ratingDouble)
    }

    var isDurationValid: Bool {
        guard let durationInt = Int(duration) else { return false }
        return durationInt > 0 && durationInt <= 600
    }

    var isGenreSelected: Bool {
        genre != nil
    }

    var isStepOneValid: Bool {
        isTitleValid && isYearValid && isRatingValid && isDurationValid && isGenreSelected
    }
}
