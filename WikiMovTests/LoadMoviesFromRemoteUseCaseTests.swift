// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

class DefaultMovieLoader: MovieLoader {
  
  private let client: HTTPClient
  private let endpoint: Endpoint
  
  private var request: URLRequest!
  
  init(client: HTTPClient, endpoint: Endpoint) throws {
    self.client = client
    self.endpoint = endpoint
    self.request = try endpoint.makeURLRequest()
  }
  
  typealias Result = MovieLoader.Result
  
  func load(completion: @escaping (Result) -> Void) {
    client.get(from: request, queue: .main) { _ in
}
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
  
  // MARK: - Helpers
  private func makeSUT(
    endpoint: Endpoint = MovieEndpoint.popular,
      file: StaticString = #filePath,
      line: UInt = #line) -> (DefaultMovieLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = try! DefaultMovieLoader(client: client, endpoint: endpoint)
        
        return (sut, client)
      }
}
