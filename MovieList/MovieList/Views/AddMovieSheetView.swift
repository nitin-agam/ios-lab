//
//  AddMovieSheetView.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 20/04/26.
//

import SwiftUI

struct AddMovieSheetView: View {

    // @StateObject: this view owns AddMovieViewModel
    @StateObject private var addMovieViewModel = AddMovieViewModel()

    // @ObservedObject: received from WatchlistView
    @ObservedObject var watchlistViewModel: WatchlistViewModel_ObservableObject

    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            Group {
                switch addMovieViewModel.currentStep {
                case .details:
                    AddMovieDetailsView(form: $addMovieViewModel.form)
                case .confirm:
                    AddMovieConfirmView(form: addMovieViewModel.form)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { sheetToolbar }
            .onAppear {
                // restore any draft from a previous session
                addMovieViewModel.restoreDraft()
            }
            .onChange(of: scenePhase) { _, newPhase in
                // save the draft when the app backgrounds
                if newPhase == .background {
                    addMovieViewModel.saveDraft()
                }
            }
        }
    }

    private var navigationTitle: String {
        switch addMovieViewModel.currentStep {
        case .details: return "Add Movie"
        case .confirm: return "Confirm Details"
        }
    }

    @ToolbarContentBuilder
    private var sheetToolbar: some ToolbarContent {
        leadingButton
        trailingButton
    }

    private var leadingButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            switch addMovieViewModel.currentStep {
            case .details:
                Button("Cancel") {
                    addMovieViewModel.reset()
                    dismiss()
                }
            case .confirm:
                Button("Back") {
                    addMovieViewModel.goBackToDetails()
                }
            }
        }
    }

    private var trailingButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            switch addMovieViewModel.currentStep {
            case .details:
                Button("Next") {
                    addMovieViewModel.goToConfirmation()
                }
                .fontWeight(.semibold)
                .disabled(!addMovieViewModel.form.isStepOneValid)

            case .confirm:
                Button("Add to Watchlist") {
                    addMovieViewModel.submitMovie(to: watchlistViewModel)
                    dismiss()
                }
                .fontWeight(.semibold)
            }
        }
    }
}
