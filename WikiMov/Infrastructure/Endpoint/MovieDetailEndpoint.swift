// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public enum MovieDetailEndpoint {
  case detail(id: Int)
}

extension MovieDetailEndpoint: Endpoint {
  public var baseURL: String {
    return "https://api.themoviedb.org"
  }
  
  public var path: String {
    switch self {
    case let .detail(id):
      return "/3/movie/\(id)"
    }
  }
  
  public var parameters: [String : Any]? {
    return ["api_key": "7157aee554910d31feca06cc84700142"]
  }
  
  public var method: HTTPMethod {
    return .get
  }
}
