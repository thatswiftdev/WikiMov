// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

struct Movies: Decodable {
  let results: [MovieResult]?
}

struct MovieResult: Decodable {
  let backdropPath: String?
  let id: Int?
  let posterPath: String?
  let releaseDate: String?
  let title: String?
  
  enum CodingKeys: String, CodingKey {
    case backdropPath
    case id
    case posterPath
    case releaseDate
    case title
  }
}
