// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

enum MovieEndpoint: String {
  case popular
}

extension MovieEndpoint: Endpoint {
  var baseURL: String {
    return "https://api.themoviedb.org"
  }
  
  var parameters: [String : Any]? {
    return ["api_key": "7157aee554910d31feca06cc84700142"]
  }
  
  var method: HTTPMethod {
    return .get
  }
  
  var path: String {
    return "/3/movie/\(rawValue)"
  }
}

class EndpointTests: XCTestCase {
  
  func test_popularMovies_endpointURL() throws {
    let endpoint: MovieEndpoint = .popular
    
    let request = try endpoint.makeURLRequest()
    
    XCTAssertEqual(request.url?.scheme, "https")
    XCTAssertEqual(request.url?.host, "api.themoviedb.org")
    XCTAssertEqual(request.url?.path, "/3/movie/popular")
  }
}
