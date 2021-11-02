// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

final class ReviewMapper {
  
  private struct Root: Decodable {
    let results: [Review]
  }
  
  private static var OK_200 = 200
  
  static func map(_ data: Data, response: HTTPURLResponse) throws -> [Review] {
    guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
      throw DefaultReviewLoader.Error.invalidData
    }
    
    return root.results
  }
}
