// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public enum RetrieveCacheDataResult {
  case empty
  case found([LocalMovie])
  case failure(Error)
}

public protocol LocalMovieStore {
  typealias InsertionCompletion = (Error?) -> Void
  typealias RemovalCompletion = (Error?) -> Void
  typealias RetrievalCompletion = (RetrieveCacheDataResult) -> Void
  typealias UpdateCompletion = (Error?) -> Void
  
  func insert(_ data: LocalMovie, completion: @escaping InsertionCompletion)
  func remove(_ data: LocalMovie, completion: @escaping RemovalCompletion)
  func retrieve(completion: @escaping RetrievalCompletion)
}
