//
//  SearchViewModel.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import Foundation
import Combine
import MovieKit
import NetworkKit

protocol SearchProtocol: ObservableObject {
    var movies: [Movie] { get }
    var searchText: String { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    func searchMovie(_ text: String, adultIncluded: Bool) async
}

class SearchViewModel: SearchProtocol {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let networkService: NetworkService
    private let endpointProvider: EndpointProvider
    private var currentTask: Task<Void, Never>?
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkService: NetworkService = URLSessionNetworkService(),
         endpointProvider: EndpointProvider = TMDBEndpointProvider()) {
        self.networkService = networkService
        self.endpointProvider = endpointProvider
        
        setupSearchSubscription()
    }
    
    @MainActor
    func searchMovie(_ text: String, adultIncluded: Bool = false) async {
        guard currentTask == nil else { return }
        
        isLoading = true
        errorMessage = nil
        
        let endpoint = endpointProvider.endpoint(for: .search(text: searchText, adult: adultIncluded))
        
        currentTask = Task {
            defer {
                self.isLoading = false
                self.currentTask = nil
            }
            
            do {
                try Task.checkCancellation()
                
                let response: MovieResponse = try await self.networkService.fetch(from: endpoint)
                
                try Task.checkCancellation()
                
                self.movies = response.results
                self.errorMessage = nil
                
            } catch is CancellationError {
                return
            } catch let error as NetworkError {
                self.errorMessage = error.userMessage
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func setupSearchSubscription<S: Scheduler>(scheduler: S = DispatchQueue.main) {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: scheduler)
            .removeDuplicates()
            .sink { [weak self] text in
                Task {
                    await self?.searchMovie(text)
                }
            }
            .store(in: &cancellables)
    }
}
