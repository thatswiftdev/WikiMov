// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

enum HTTPMethod: String {
  case get = "GET"
}

protocol Endpoint {
  var baseURL: URL { get }
  var path: String { get }
  var parameters: [String: Any]? { get }
  var method: HTTPMethod { get }
}
