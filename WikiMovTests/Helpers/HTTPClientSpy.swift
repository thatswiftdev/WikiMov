// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

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
