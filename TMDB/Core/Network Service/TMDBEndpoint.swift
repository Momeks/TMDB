//
//  TMDBEndPoint.swift
//  TMDB
//
//  Created by Mohammad Komeili on 28.05.25.
//

import Foundation
import NetworkKit

enum TMDBPath {
    case movieList(type: String, page: Int)
    case custom(path: String, query: [URLQueryItem])
    
    var path: String {
        switch self {
        case .movieList(let type, _):
            return "movie/\(type)"
        case .custom(let path, _):
            return path
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .movieList(_, let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .custom(_, let query):
            return query
        }
    }
}

struct TMDBEndpoint: Endpoint {
    let pathType: TMDBPath
    let accessToken: String
    
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        pathType.path
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String: String]? {
        [
            "accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }
    
    var queryItems: [URLQueryItem]? {
        pathType.queryItems
    }
    
    var body: Data? {
        nil
    }
}
