//
//  MovieListViewModel.swift
//  TMDB
//
//  Created by Mohammad Komeili on 28.05.25.
//

import Foundation
import Combine
import MovieKit
import NetworkKit

protocol MovieListProtocol: ObservableObject {
    var movies: [Movie] { get }
    var isLoading: Bool { get }
    var isLoadingNextPage: Bool { get }
    var errorMessage: String? { get }
    var currentPage: Int { get }
    func fetchMovies() async
    func loadNextPage() async
    func refresh() async
}

class MovieListViewModel: MovieListProtocol {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var isLoadingNextPage = false
    @Published var errorMessage: String?
    
    private(set) var currentPage: Int = 0
    private let networkService: NetworkService
    private let endpointProvider: EndpointProvider
    private var currentTask: Task<Void, Never>?
    
    init(netowrkService: NetworkService = URLSessionNetworkService(),
         endpointProvider: EndpointProvider = TMDBEndpointProvider()) {
        self.networkService = netowrkService
        self.endpointProvider = endpointProvider
        
        Task {
            await fetchMovies()
        }
    }
    
    @MainActor
    private func fetchMovies(page: Int) async {
        cancelTask()
        
        let isInitialLoad = page == 1
        
        if isInitialLoad {
            isLoading = true
            errorMessage = nil
        } else {
            isLoadingNextPage = true
        }
        
        let endpoint = endpointProvider.endpoint(for: .movieList(type: AppConfig.listType.rawValue, page: page))
        
        currentTask = Task {
            defer {
                self.isLoading = false
                self.isLoadingNextPage = false
                self.currentTask = nil
            }
            
            do {
                try Task.checkCancellation()
                
                let response: MovieResponse = try await self.networkService.fetch(from: endpoint)
                
                try Task.checkCancellation()
                
                self.currentPage = page
                if isInitialLoad {
                    self.movies = response.results
                } else {
                    self.movies.append(contentsOf: response.results)
                }
                
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
    
    func fetchMovies() async {
        await fetchMovies(page: 1)
    }
    
    func refresh() async {
        currentPage = 0
        await fetchMovies(page: 1)
    }
    
    func loadNextPage() async {
        guard !isLoadingNextPage && currentTask == nil else { return }
        await fetchMovies(page: currentPage + 1)
    }
    
    private func cancelTask() {
        currentTask?.cancel()
        currentTask = nil
    }
}
