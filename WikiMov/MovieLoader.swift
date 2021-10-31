// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public protocol MovieLoader {
  typealias Result = Swift.Result<Movies, Error>
  
  func load(completion: @escaping (Result) -> Void)
}
