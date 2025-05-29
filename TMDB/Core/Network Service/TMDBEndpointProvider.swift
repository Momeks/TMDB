//
//  TMDBEndpointProvider.swift
//  TMDB
//
//  Created by Mohammad Komeili on 28.05.25.
//


import Foundation
import NetworkKit

protocol EndpointProvider {
    func endpoint(for path: TMDBPath) -> Endpoint
}

class TMDBEndpointProvider: EndpointProvider {
    private let accessToken: String
    
    init(accessToken: String = APIKeyProvider.shared.accessToken) {
        self.accessToken = accessToken
    }
    
    func endpoint(for path: TMDBPath) -> Endpoint {
        return TMDBEndpoint(pathType: path, accessToken: accessToken)
    }
}
