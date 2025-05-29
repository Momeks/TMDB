//
//  MovieList.swift
//  TMDB
//
//  Created by Mohammad Komeili on 28.05.25.
//

import Foundation

enum MovieList: String {
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case upcoming = "upcoming"
    case popular = "popular"
    
    var tilte: String {
        switch self {
        case .nowPlaying:
            "Now Playing"
        case .topRated:
            "Top Rated"
        case .upcoming:
            "Upcoming"
        case .popular:
            "Popular"
        }
    }
}
