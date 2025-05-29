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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedMovie: Movie? = nil
    @State private var showSearch: Bool = false
    @Namespace private var namespace
    
    private var gridColumns: [GridItem] {
        let gridConfig = GridLayoutConfiguration.default
        let columnCount = horizontalSizeClass == .regular ?
        gridConfig.regularColumns : gridConfig.compactColumns
        return Array(repeating: GridItem(.flexible(), spacing: gridConfig.spacing), count: columnCount)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
            
                } else if viewModel.errorMessage != nil {
                    ErrorView(description: viewModel.errorMessage ?? "") {
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
                        showSearch.toggle()
                    }
                }
            }
            .sheet(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
                    .navigationTransition(.zoom(sourceID: movie.id, in: namespace))
            }
            .navigationDestination(isPresented: $showSearch) {
                SearchView(viewModel: SearchViewModel())
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
