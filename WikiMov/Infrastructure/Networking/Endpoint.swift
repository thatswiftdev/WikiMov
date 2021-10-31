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

public enum RequestGenerationError: Error {
  case components
  case urlError
}

public extension Endpoint {
  private func makeURL() throws -> URL? {
    guard var components = URLComponents(string: baseURL) else {
      throw RequestGenerationError.components
    }
    components.path = path
    
    if let parameters = parameters {
      components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)" )}
    }
    return components.url
  }

  func makeURLRequest() throws -> URLRequest {
    guard let url = try? self.makeURL() else { throw RequestGenerationError.urlError }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return request
  }

}
