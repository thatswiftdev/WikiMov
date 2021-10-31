// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

class DefaultMovieLoader: MovieLoader {
  
  private let client: HTTPClient
  private let endpoint: Endpoint
  
  private var request: URLRequest!
  
  public enum Error: Swift.Error {
    case connectivity
    case invalidData
  }
  
  init(client: HTTPClient, endpoint: Endpoint) throws {
    self.client = client
    self.endpoint = endpoint
    self.request = try endpoint.makeURLRequest()
  }
  
  typealias Result = MovieLoader.Result
  
  func load(completion: @escaping (Result) -> Void) {
    client.get(from: request, queue: .main) { result in
      switch result {
        
      case let .success((data, response)):
        completion(DefaultMovieLoader.map(data: data, from: response))
        
      case .failure:
        completion(.failure(Error.connectivity))
      }
    }
  }
  
  private static func map(data: Data, from response: HTTPURLResponse) -> DefaultMovieLoader.Result {
    do {
      let movies = try MoviesMapper.map(data, response: response)
      return .success(movies)
    } catch {
      return .failure(error)
    }
  }
}

final class MoviesMapper {
  
  private struct Root: Decodable {
    let results: [Movie]
  }
  
  private static var OK_200 = 200
  
  static func map(_ data: Data, response: HTTPURLResponse) throws -> [Movie] {
    guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
      throw DefaultMovieLoader.Error.invalidData
    }
    
    return root.results
  }
}

protocol HTTPClient {
  typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
  
  func get(from request: URLRequest, queue: DispatchQueue, completion: @escaping (Result) -> Void)
}

class HTTPClientSpy: HTTPClient {
  
  private var messages = [(request: URLRequest, completion: (HTTPClient.Result) -> Void)]()
  
  var requestedURLs: [URLRequest] {
    return messages.compactMap { $0.request }
  }
  
  func get(from request: URLRequest, queue: DispatchQueue = .main, completion: @escaping (HTTPClient.Result) -> Void) {
    messages.append((request, completion))
  }
  
  func complete(with error: Error, at index: Int = 0) {
    messages[index].completion(.failure(error))
  }
  
  func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
    let response = HTTPURLResponse(url: requestedURLs[index].url!, statusCode: code, httpVersion: nil, headerFields: nil)!
    messages[index].completion(.success((data, response)))
  }
}

class LoadMoviesFromRemoteUseCaseTests: XCTestCase {
  
  func test_init_doesNotRequestDataFromURL() {
    let (_, client) = makeSUT()
    
    XCTAssertTrue(client.requestedURLs.isEmpty)
  }
  
  func test_load_shouldRequestDataFromURL() throws {
    let (sut, client) = makeSUT()
    
    let endpoint = try MovieEndpoint.popular.makeURLRequest()
    
    sut.load { _ in }
    
    XCTAssertEqual(client.requestedURLs, [endpoint])
  }
  
  func test_loadTwice_shouldRequestDataFromURLTwice() throws {
    let (sut, client) = makeSUT()
    
    let endpoint = try MovieEndpoint.popular.makeURLRequest()
    
    sut.load { _ in }
    sut.load { _ in }
    
    XCTAssertEqual(client.requestedURLs, [endpoint, endpoint])
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
    var capturedErrors = [DefaultMovieLoader.Error]()
    
    let statusCodes = [199, 201, 300, 400, 500]
    
    for (index, code) in statusCodes.enumerated() {
      expect(sut, toCompleteWithResult: failure(.invalidData)) {
        let moviesJSON = makeMoviesJSON([])
        client.complete(withStatusCode: code, data: moviesJSON, at: index)
        capturedErrors.removeAll()
      }
    }
  }
  
  // MARK: - Helpers
  private func makeSUT(
    endpoint: Endpoint = MovieEndpoint.popular,
      file: StaticString = #filePath,
      line: UInt = #line) -> (DefaultMovieLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = try! DefaultMovieLoader(client: client, endpoint: endpoint)
        
        return (sut, client)
      }
  
  private func failure(_ error: DefaultMovieLoader.Error) -> DefaultMovieLoader.Result {
    return .failure(error)
  }
  
  private func expect(_ sut: DefaultMovieLoader, toCompleteWithResult expectedResult: MovieLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
    
    let exp = expectation(description: "Wait for load completion")
    
    sut.load { receivedResult in
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
}
