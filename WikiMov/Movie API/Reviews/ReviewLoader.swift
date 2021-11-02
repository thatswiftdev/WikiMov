// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public protocol ReviewLoader {
  typealias Result = Swift.Result<[Review], Error>
  
  func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void)
}
