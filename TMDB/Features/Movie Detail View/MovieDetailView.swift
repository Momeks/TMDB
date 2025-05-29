//
//  MovieDetailView.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import SwiftUI
import MovieKit

struct MovieDetailView: View {
    var movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                VStack(spacing: -50) {
                    RemoteImageView(url: movie.backdropURL())
                    
                    RemoteImageView(url: movie.posterURL())
                        .frame(width: 170, height: 250)
                        .shadow(radius: 10)
                }
                
                Group {
                    Text(movie.title)
                        .bold()
                        .font(.title)
                  
                    Text(movie.genres.formatted())
                        .bold()
                        .italic()
                    
                    Text(movie.overview)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 10) {
                        Label(movie.releaseYear ?? "-", systemImage: "calendar")
                            .foregroundStyle(.gray)
                        
                        Divider()
                        
                        Label(movie.formattedRating, systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                        
                        Divider()
                        
                        Label(movie.voteCount.formatted(), systemImage: "hand.thumbsup.fill")
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MovieDetailView(movie: Movie.previews.first!)
}
