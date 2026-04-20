//
//  AddMovieDetailsView.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 20/04/26.
//

import SwiftUI

struct AddMovieDetailsView: View {
    
    @Binding var form: AddMovieForm
    @FocusState private var focusedField: AddMovieForm.Field?

    var body: some View {
        Form {
            movieDetailsSection
            genreSection
            synopsisSection
        }
    }

    private var movieDetailsSection: some View {
        Section("Movie Details") {
            titleField
            yearField
            ratingField
            durationField
        }
    }

    private var titleField: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Title", text: $form.title)
                .focused($focusedField, equals: .title)
                .onChange(of: focusedField) { oldField, _ in
                    if oldField == .title { form.markTouched(.title) }
                }

            if form.isTouched(.title) && !form.isTitleValid {
                Text("Title must be at least 2 characters")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private var yearField: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Year", text: $form.year)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .year)
                .onChange(of: focusedField) { oldField, _ in
                    if oldField == .year { form.markTouched(.year) }
                }

            if form.isTouched(.year) && !form.isYearValid {
                Text("Enter a valid year between 1888 and today")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private var ratingField: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Rating (0 – 10)", text: $form.rating)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .rating)
                .onChange(of: focusedField) { oldField, _ in
                    if oldField == .rating { form.markTouched(.rating) }
                }

            if form.isTouched(.rating) && !form.isRatingValid {
                Text("Rating must be between 0 and 10")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private var durationField: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Duration (minutes)", text: $form.duration)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .duration)
                .onChange(of: focusedField) { oldField, _ in
                    if oldField == .duration { form.markTouched(.duration) }
                }

            if form.isTouched(.duration) && !form.isDurationValid {
                Text("Enter duration in minutes (1 – 600)")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private var genreSection: some View {
        Section("Genre") {
            Picker("Genre", selection: $form.genre) {
                Text("Select a genre").tag(Optional<Movie.Genre>.none)
                ForEach(Movie.Genre.allCases, id: \.self) { genre in
                    Text(genre.rawValue).tag(Optional(genre))
                }
            }
            .onChange(of: form.genre) { _, _ in
                form.markTouched(.genre)
            }

            if form.isTouched(.genre) && !form.isGenreSelected {
                Text("Please select a genre")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private var synopsisSection: some View {
        Section("Synopsis") {
            TextField("Brief description...", text: $form.synopsis, axis: .vertical)
                .lineLimit(3...6)
        }
    }
}
