// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public struct Movies: Equatable, Decodable {
  let results: [MovieResult]?
}

public struct MovieResult: Equatable, Decodable {
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
