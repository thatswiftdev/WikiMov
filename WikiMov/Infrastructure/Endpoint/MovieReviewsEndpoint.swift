// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public enum MovieReviewsEndpoint {
  case reviews(movieId: Int)
}

extension MovieReviewsEndpoint: Endpoint {
  public var baseURL: String {
    return "https://api.themoviedb.org"
  }
  
  public var path: String {
    switch self {
    case let .reviews(id):
      return "/3/movie/\(id)/reviews"
    }
  }
  
  public var parameters: [String : Any]? {
    return ["api_key": "7157aee554910d31feca06cc84700142"]
  }
  
  public var method: HTTPMethod {
    return .get
  }
}
