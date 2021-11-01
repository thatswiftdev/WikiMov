// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
  
  private let session: URLSession
  
  public init(session: URLSession = .shared) {
    self.session = session
  }
  
  public func get(from request: URLRequest, queue: DispatchQueue, completion: @escaping (HTTPClient.Result) -> Void) {
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        queue.async {
          completion(.failure(error))
        }
      } else if let data = data, let response = response as? HTTPURLResponse {
        queue.async {
          completion(.success((data, response)))
        }
      }
    }.resume()
  }
}
