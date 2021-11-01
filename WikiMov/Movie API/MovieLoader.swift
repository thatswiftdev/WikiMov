// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public protocol MovieLoader {
  typealias Result = Swift.Result<[Movie], Error>
  
  func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void)
}
