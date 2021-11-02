// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

final class MovieDetailMapper {
  
  private static var OK_200 = 200
  
  static func map(_ data: Data, response: HTTPURLResponse) throws -> Movie {
    guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Movie.self, from: data) else {
      throw DefaultMovieDetailLoader.Error.invalidData
    }
    
    return root
  }
}

