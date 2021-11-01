// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public struct Movie: Hashable, Decodable {
  let id: Int?
  let title: String?
  let backdrop_path: String?
  let poster_path: String?
  let release_date: String?
  
  
  public init(
    id: Int?,
    title: String?,
    backdropPath: String?,
    posterPath: String?,
    releaseDate: String?)
  {
    self.id = id
    self.title = title
    self.backdrop_path = backdropPath
    self.poster_path = posterPath
    self.release_date = releaseDate
  }
}
