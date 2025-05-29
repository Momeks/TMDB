//
//  MovieItem.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import SwiftUI
import MovieKit

struct MovieItem: View {
    var movie: Movie
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            VStack(alignment: .center) {
                RemoteImageView(url: movie.posterURL())
                    .frame(width: 120, height: 180)
                
                Text(movie.originalTitle)
                    .bold()
                    .frame(width: 120)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(movie.formattedReleasedDate ?? "")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MovieItem(movie: Movie.previews.first!)
}
