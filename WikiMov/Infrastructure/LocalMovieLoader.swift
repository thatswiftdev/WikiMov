// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public enum LoadDataResult {
  case success([LocalMovie])
  case failure(Error)
}

public protocol LocalMovieLoader {
  typealias SaveResult = Error?
  typealias DeleteResult = Error?
  
  func load(completion: @escaping (LoadDataResult) -> Void)
  func save(_ data: LocalMovie, completion: @escaping (SaveResult) -> Void)
  func delete(_ data: LocalMovie, completion: @escaping (DeleteResult) -> Void)
}
