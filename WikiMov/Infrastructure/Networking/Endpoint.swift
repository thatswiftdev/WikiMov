// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public enum HTTPMethod: String {
  case get = "GET"
}

public protocol Endpoint {
  var baseURL: String { get }
  var path: String { get }
  var parameters: [String: Any]? { get }
  var method: HTTPMethod { get }
}

public extension Endpoint {
  private func makeURL() -> URL? {
    guard var components = URLComponents(string: baseURL) else {
      fatalError("Failed to create URLComponents")
    }
    components.path = path
    
    if let parameters = parameters {
      components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)" )}
    }
    return components.url
  }

  func makeURLRequest() -> URLRequest {
    guard let url = self.makeURL() else { fatalError("Failed to create URL") }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return request
  }
}
