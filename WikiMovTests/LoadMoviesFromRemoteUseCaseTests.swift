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
    client.get(from: request, queue: .main) { _ in
      completion(.failure(Error.connectivity))
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
  
  func complete(with error: Error, at index: Int = 0) {
    messages[index].completion(.failure(error))
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
    let exp = expectation(description: "Wait for load completion")
    
    sut.load { result in
      switch result {
      case let .failure(error as DefaultMovieLoader.Error):
        XCTAssertEqual(error, .connectivity)
        
      default:
        break
      }
      exp.fulfill()
    }
    
    client.complete(with: clientError)
    
    wait(for: [exp], timeout: 1.0)

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
