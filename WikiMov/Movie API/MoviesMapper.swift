// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

final class MoviesMapper {
  
  private struct Root: Decodable {
    let results: [Movie]
  }
  
  private static var OK_200 = 200
  
  static func map(_ data: Data, response: HTTPURLResponse) throws -> [Movie] {
    guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
      throw DefaultMovieLoader.Error.invalidData
    }
    
    return root.results
  }
}
