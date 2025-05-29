//
//  TMDBApp.swift
//  TMDB
//
//  Created by Mohammad Komeili on 28.05.25.
//

import SwiftUI

@main
struct TMDBApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView(viewModel: MovieListViewModel())
        }
    }
}
