//
//  AddMovieConfirmView.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 20/04/26.
//

import SwiftUI

struct AddMovieConfirmView: View {
    
    let form: AddMovieForm

    var body: some View {
        Form {
            Section("Review Your Movie") {
                LabeledContent("Title", value: form.title)
                LabeledContent("Genre", value: form.genre?.rawValue ?? "")
                LabeledContent("Year", value: form.year)
                LabeledContent("Rating", value: "\(form.rating) / 10")
                LabeledContent("Duration", value: "\(form.duration) min")
            }

            if !form.synopsis.isEmpty {
                Section("Synopsis") {
                    Text(form.synopsis)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            }

            Section {
                Text("Tap \"Add to Watchlist\" to confirm.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}
