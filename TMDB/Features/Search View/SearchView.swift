//
//  SearchView.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import SwiftUI
import MovieKit

struct SearchView<ViewModel: SearchViewModel>: View {
    @StateObject var viewModel: ViewModel
    @State private var selectedMovie: Movie? = nil
    @Namespace private var namespace
    
    private let gridColumns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(description: errorMessage) {
                        Task {
                            await viewModel.searchMovie(viewModel.searchText)
                        }
                    }
                } else if viewModel.isEmptyResult {
                    ContentUnavailableView(
                        "No Movies Found",
                        systemImage: "magnifyingglass",
                        description: Text("Try searching with different keywords")
                    )
                } else if viewModel.movies.isEmpty {
                    ContentUnavailableView(
                        "Search Movies",
                        systemImage: "film",
                        description: Text("Enter a movie title to start searching")
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 16) {
                            ForEach(viewModel.movies) { movie in
                                MovieItem(movie: movie) {
                                    selectedMovie = movie
                                }
                                .matchedGeometryEffect(id: movie.id, in: namespace)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, prompt: "Movie title...")
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.setupSearchSubscription()
            }
            .sheet(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
                    .matchedGeometryEffect(id: movie.id, in: namespace)
                    .navigationTransition(.zoom(sourceID: movie.id, in: namespace))
            }
        }
    }
}
