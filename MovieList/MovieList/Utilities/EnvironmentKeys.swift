//
//  EnvironmentKeys.swift
//  MovieList
//
//  Created by Nitin Aggarwal on 29/03/26.
//

import SwiftUI

private struct MaxGenreChipsKey: EnvironmentKey {
    static let defaultValue: Int = 5
}

extension EnvironmentValues {
    var maxGenreChips: Int {
        get { self[MaxGenreChipsKey.self] }
        set { self[MaxGenreChipsKey.self] = newValue }
    }
}
