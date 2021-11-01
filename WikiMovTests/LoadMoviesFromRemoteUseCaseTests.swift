// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

class LoadMoviesFromRemoteUseCaseTests: XCTestCase {
  
  func test_init_doesNotRequestDataFromURL() {
    let (_, client) = makeSUT()
    
    XCTAssertTrue(client.requestedURLs.isEmpty)
  }
  
  func test_load_shouldRequestDataFromURL() throws {
    let (sut, client) = makeSUT()
    
    let endpoint = MovieEndpoint.popular
    
    sut.load(from: endpoint) { _ in }
    
    XCTAssertEqual(client.requestedURLs, [endpoint.makeURLRequest()])
  }
  
  func test_loadTwice_shouldRequestDataFromURLTwice() throws {
    let (sut, client) = makeSUT()
    
    let endpoint = MovieEndpoint.popular
    
    sut.load(from: endpoint) { _ in }
    sut.load(from: endpoint) { _ in }
    
    XCTAssertEqual(client.requestedURLs, [endpoint.makeURLRequest(), endpoint.makeURLRequest()])
  }
  
  func test_load_deliversErrorOnClientError() {
    let (sut, client) = makeSUT()
    let clientError = NSError(domain: "Any", code: 0)
    
    expect(sut, toCompleteWithResult: failure(.connectivity)) {
      client.complete(with: clientError)
    }
  }
  
  func test_load_deliversErrorOnNon200HTTPResponse() {
    let (sut, client) = makeSUT()
    
    let statusCodes = [199, 201, 300, 400, 500]
    
    for (index, code) in statusCodes.enumerated() {
      expect(sut, toCompleteWithResult: failure(.invalidData)) {
        let moviesJSON = makeMoviesJSON([])
        client.complete(withStatusCode: code, data: moviesJSON, at: index)
      }
    }
  }
  
  func test_load_deliversErrorOn200HTTPResponseWithInvalidJSONData() {
    let (sut, client) = makeSUT()
    
    expect(sut, toCompleteWithResult: failure(.invalidData)) {
      let invalidJSONData = Data("invalid-json".utf8)
      client.complete(withStatusCode: 200, data: invalidJSONData)
    }
  }
  
  func test_load_deliversMoviesOn200HTTPResponseWithEmptyJSONList() {
    let (sut, client) = makeSUT()
    
    expect(sut, toCompleteWithResult: .success([])) {
      let emptyMoviesJSON = makeMoviesJSON([])
      client.complete(withStatusCode: 200, data: emptyMoviesJSON)
    }
  }
  
  func test_load_deliversMoviesOn200HTTPResponseWithJSONList() {
    let (sut, client) = makeSUT()
    
    let movie1 = makeMovie(id: 1, title: "Movie 1", backdropPath: "Backdrop 1", posterPath: "Poster 1", releaseDate: "2021-10-20", overview: "Overview 1")
    let movie2 = makeMovie(id: 2, title: "Movie 2", backdropPath: "Backdrop 2", posterPath: "Poster 2", releaseDate: "2021-10-22", overview: "Overview 1")
    
    let movies = [movie1.movie, movie2.movie]
    
    expect(sut, toCompleteWithResult: .success(movies)) {
      let jsonList = makeMoviesJSON([movie1.json, movie2.json])
      client.complete(withStatusCode: 200, data: jsonList)
    }
  }
  
  func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
    let endpoint = MovieEndpoint.nowPlaying
    let client = HTTPClientSpy()
    var sut: DefaultMovieLoader? = DefaultMovieLoader(client: client)
    
    var capturedResults: [DefaultMovieLoader.Result] = []
    sut?.load(from: endpoint) { result in capturedResults.append(result) }
    
    sut = nil
    client.complete(withStatusCode: 200, data: makeMoviesJSON([]))
    
    XCTAssertTrue(capturedResults.isEmpty)
  }
  
  // MARK: - Helpers
  private func makeSUT(
    file: StaticString = #filePath,
    line: UInt = #line) -> (DefaultMovieLoader, HTTPClientSpy) {
      let client = HTTPClientSpy()
      let sut = DefaultMovieLoader(client: client)
      trackForMemoryLeaks(for: sut, file: file, line: line)
      trackForMemoryLeaks(for: client, file: file, line: line)
      return (sut, client)
    }
  
  private func failure(_ error: DefaultMovieLoader.Error) -> DefaultMovieLoader.Result {
    return .failure(error)
  }
  
  private func expect(_ sut: DefaultMovieLoader, toCompleteWithResult expectedResult: MovieLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
    
    let exp = expectation(description: "Wait for load completion")
    
    sut.load(from: MovieEndpoint.popular) { receivedResult in
      switch (receivedResult, expectedResult) {
      case let (MovieLoader.Result.success(receivedMovies), MovieLoader.Result.success(expectedMovies)):
        XCTAssertEqual(receivedMovies, expectedMovies, file: file, line: line)
        
      case let (MovieLoader.Result.failure(receivedError as DefaultMovieLoader.Error), MovieLoader.Result.failure(expectedError as DefaultMovieLoader.Error)):
        XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        
      default:
        XCTFail("Expected result \(expectedResult), but got \(receivedResult) instead.", file: file, line: line)
      }
      
      exp.fulfill()
    }
    action()
    
    wait(for: [exp], timeout: 2.0)
  }
  
  private func makeMoviesJSON(_ results: [[String: Any]]) -> Data {
    let itemsJSON = [
      "results": results
    ]
    return try! JSONSerialization.data(withJSONObject: itemsJSON)
  }
  
  private func makeMovie(id: Int, title: String, backdropPath: String, posterPath: String, releaseDate: String, overview: String) -> (movie: Movie, json: [String: Any]) {
    let movie = Movie(
      id: id,
      title: title,
      backdropPath: backdropPath,
      posterPath: posterPath,
      releaseDate: releaseDate,
      overview: overview
    )
    
    let json: [String: Any] = [
      "id": id,
      "title": title,
      "backdrop_path": backdropPath,
      "poster_path": posterPath,
      "release_date": releaseDate,
      "overview": overview
    ]
    
    return (movie, json)
  }
}
