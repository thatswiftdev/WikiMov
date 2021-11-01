// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public final class DefaultLocalMovieLoader {
  
  private let store: LocalMovieStore
  
  public init(store: LocalMovieStore) {
    self.store = store
  }
}

extension DefaultLocalMovieLoader: LocalMovieLoader {
  public typealias LoadResult = LoadDataResult
  
  public func load(completion: @escaping (LoadResult) -> Void) {
    store.retrieve { [weak self] result in
      guard self != nil else { return }
      
      switch result {
      case let .failure(error):
        completion(.failure(error))
        
      case .empty:
        completion(.success([]))
        
      case let .found(data):
        completion(.success(data))
      }
    }
  }
}

extension DefaultLocalMovieLoader {
  public func save(_ data: LocalMovie, completion: @escaping (SaveResult) -> Void) {
    store.insert(data) { [weak self] error in
      guard self != nil else { return }
      
      completion(error)
    }
  }
}

extension DefaultLocalMovieLoader {
  public func delete(_ data: LocalMovie, completion: @escaping (DeleteResult) -> Void) {
    store.remove(data) { [weak self] error in
      guard self != nil else { return }
      
      completion(error)
    }
  }
}
