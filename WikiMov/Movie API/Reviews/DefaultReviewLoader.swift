// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public class DefaultReviewLoader: ReviewLoader {
  
  private let client: HTTPClient

  public enum Error: Swift.Error {
    case connectivity
    case invalidData
  }
  
  public init(client: HTTPClient) {
    self.client = client
  }
  
  public typealias Result = ReviewLoader.Result
  
  public func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {
    client.get(from: endpoint.makeURLRequest(), queue: .main) { [weak self] result in
      guard self != nil else { return }
      
      switch result {
        
      case let .success((data, response)):
        completion(DefaultReviewLoader.map(data: data, from: response))
        
      case .failure:
        completion(.failure(Error.connectivity))
      }
    }
  }
  
  private static func map(data: Data, from response: HTTPURLResponse) -> DefaultReviewLoader.Result {
    do {
      let reviews = try ReviewMapper.map(data, response: response)
      return .success(reviews)
    } catch {
      return .failure(error)
    }
  }
}
