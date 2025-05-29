//
//  MovieListView.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import SwiftUI
import MovieKit

struct MovieListView<ViewModel: MovieListViewModel>: View {
    @StateObject var viewModel: ViewModel
    @State private var selectedMovie: Movie? = nil
    
    @Namespace private var namespace
    
    private let gridColumns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
            
                } else if viewModel.errorMessage != nil {
                    ErrorView(title: viewModel.errorMessage ?? "") {
                        refresh()
                    }
                    
                } else {
                    ScrollView {
                        LazyVGrid(columns: gridColumns) {
                            ForEach(viewModel.movies) { movie in
                                MovieItem(movie: movie) {
                                    selectedMovie = movie
                                }
                                .matchedGeometryEffect(id: movie.id, in: namespace)
                                .onAppear {
                                    if viewModel.movies.last?.id == movie.id {
                                        loadNextPage()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(AppConfig.listType.tilte)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("search", systemImage: "magnifyingglass") {
                    }
                }
            }
            .sheet(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
                    .matchedGeometryEffect(id: movie.id, in: namespace)
                    .navigationTransition(.zoom(sourceID: movie.id, in: namespace))
            }
        }
    }
}

#Preview {
    MovieListView(viewModel: MovieListViewModel())
}

// MARK: - Functions
extension MovieListView {
    private func refresh() {
        Task {
            await viewModel.refresh()
        }
    }
    
    private func loadNextPage() {
        Task {
            await viewModel.loadNextPage()
        }
    }
}
