// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

protocol HTTPClient {
  typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
}

class HTTPClientSpy {
  private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
  
  var requestedURLs: [URL] {
    return messages.map { $0.url }
  }
}

class LoadMoviesFromRemoteUseCaseTests: XCTestCase {
  
  func test_init_doesNotRequestDataFromURL() {
    let client = HTTPClientSpy()
    
    XCTAssertTrue(client.requestedURLs.isEmpty)
  }
}
