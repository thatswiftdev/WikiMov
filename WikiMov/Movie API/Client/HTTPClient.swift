// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public protocol HTTPClient {
  typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
  
  func get(from request: URLRequest, queue: DispatchQueue, completion: @escaping (Result) -> Void)
}
