// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public enum MovieEndpoint: String {
  case popular
  case nowPlaying = "now_playing"
  case topRated = "top_rated"
}

extension MovieEndpoint: Endpoint {
  public var baseURL: String {
    return "https://api.themoviedb.org"
  }
  
  public var parameters: [String : Any]? {
    return ["api_key": "7157aee554910d31feca06cc84700142"]
  }
  
  public var method: HTTPMethod {
    return .get
  }
  
  public var path: String {
    return "/3/movie/\(rawValue)"
  }
}
