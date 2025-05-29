//
//  MovieListViewModelTests.swift
//  MovieListViewModelTests
//
//  Created by Mohammad Komeili on 28.05.25.
//

import Combine
import MovieKit
import NetworkKit
import XCTest

@testable import TMDB

final class MovieListViewModelTests: XCTestCase {
    private var mockService: MockNetworkService!
    private var cancellables: Set<AnyCancellable>!
    private var mockResponse: MovieResponse!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        cancellables = []
        
        mockResponse = MovieResponse(
            dates: nil,
            page: 1,
            results: Movie.previews,
            totalPages: 1,
            totalResults: 2
        )
    }

    func test_fetchMovies_returnsMoviesSuccessfully() async throws {
        mockService.mockData = mockResponse
        let viewModel = MovieListViewModel(networkService: mockService)
        
        let expectation = expectation(description: "Movies successfully fetched")
        
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 2)
                XCTAssertEqual(movies.first?.title, "Shazam! Fury of the Gods")
                XCTAssertEqual(movies.first?.id, 594767)
                XCTAssertEqual(movies.last?.title, "John Wick: Chapter 4")
                XCTAssertEqual(movies.last?.voteAverage, 8.0)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await viewModel.fetchMovies()
        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    func test_fetchMovies_setsErrorMessageOnFailure() async throws {
        mockService.shouldThrowError = true
        mockService.errorToThrow = .invalidResponse
        let viewModel = MovieListViewModel(networkService: mockService)
        
        let expectation = expectation(description: "Movies fetch should fail with error")
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .first()
            .sink { errorMessage in
                XCTAssertTrue(errorMessage.contains("Something went wrong. Please try again."))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await viewModel.fetchMovies()
        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    override func tearDown() {
        super.tearDown()
        mockService = nil
    }
}
