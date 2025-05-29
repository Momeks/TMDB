//
//  MovieListView.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import SwiftUI

struct MovieListView<ViewModel: MovieListViewModel>: View {
    @StateObject var viewModel: ViewModel
    let gridColumns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(viewModel.movies) { movie in
                        MovieItem(movie: movie)
                    }
                }
            }
            .navigationTitle(AppConfig.listType.tilte.capitalized)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("refresh", systemImage: "arrow.clockwise") {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MovieListView(viewModel: MovieListViewModel())
}
