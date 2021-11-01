// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public class DefaultMovieLoader: MovieLoader {
  
  private let client: HTTPClient

  public enum Error: Swift.Error {
    case connectivity
    case invalidData
  }
  
  public init(client: HTTPClient) {
    self.client = client
  }
  
  public typealias Result = MovieLoader.Result
  
  public func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {
    client.get(from: endpoint.makeURLRequest(), queue: .main) { [weak self] result in
      guard self != nil else { return }
      
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
