//
//  TMDBApp.swift
//  TMDB
//
//  Created by Mohammad Komeili on 28.05.25.
//

import SwiftUI

@main
struct TMDBApp: App {
    @StateObject var viewModel = MovieListViewModel()
    var body: some Scene {
        WindowGroup {
            Text(viewModel.errorMessage ?? "haha")
        }
    }
}
