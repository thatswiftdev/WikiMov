// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
  
  private let session: URLSession
  private let logger: Logger
  
  public init(session: URLSession = .shared, logger: Logger = DefaultNetworkLogger()) {
    self.session = session
    self.logger = logger
  }
  
  public func get(from request: URLRequest, queue: DispatchQueue, completion: @escaping (HTTPClient.Result) -> Void) {
    session.dataTask(with: request) { [weak self] data, response, error in
      if let error = error {
        queue.async {
          completion(.failure(error))
        }
      } else if let data = data,
                let response = response as? HTTPURLResponse {
        queue.async {
          completion(.success((data, response)))
        }
        self?.logger.log(response)
      }
    }.resume()
  }
}
