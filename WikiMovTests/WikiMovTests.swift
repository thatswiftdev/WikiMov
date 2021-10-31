// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

class EndpointTests: XCTestCase {
  
  func test_popularMovies_endpointURL() throws {
    let request = try makeEndpoint(MovieEndpoint.popular)
    
    XCTAssertEqual(request.url?.scheme, "https")
    XCTAssertEqual(request.url?.host, "api.themoviedb.org")
    XCTAssertEqual(request.url?.path, "/3/movie/popular")
    XCTAssertEqual(request.url?.query, "api_key=7157aee554910d31feca06cc84700142")
  }
  
  func test_nowPlayingMovies_endpointURL() throws {
    let request = try makeEndpoint(MovieEndpoint.nowPlaying)
    
    XCTAssertEqual(request.url?.scheme, "https")
    XCTAssertEqual(request.url?.host, "api.themoviedb.org")
    XCTAssertEqual(request.url?.path, "/3/movie/now_playing")
    XCTAssertEqual(request.url?.query, "api_key=7157aee554910d31feca06cc84700142")
  }
  
  func test_topRatedMovies_endpointURL() throws {
    let request = try makeEndpoint(MovieEndpoint.topRated)
    
    XCTAssertEqual(request.url?.scheme, "https")
    XCTAssertEqual(request.url?.host, "api.themoviedb.org")
    XCTAssertEqual(request.url?.path, "/3/movie/top_rated")
    XCTAssertEqual(request.url?.query, "api_key=7157aee554910d31feca06cc84700142")
  }
  
  // MARK: - Helpers
  private func makeEndpoint(_ endpoint: Endpoint) throws -> URLRequest {
    let request = try endpoint.makeURLRequest()
    return request
  }
}
