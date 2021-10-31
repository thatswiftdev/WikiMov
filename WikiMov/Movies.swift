// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public struct Movie: Hashable, Decodable {
  let id: Int?
  let title: String?
  let backdropPath: String?
  let posterPath: String?
  let releaseDate: String?
  
  
  public init(
    id: Int?,
    backdropPath: String?,
    posterPath: String?,
    releaseDate: String?,
    title: String?)
  {
    self.id = id
    self.title = title
    self.backdropPath = backdropPath
    self.posterPath = posterPath
    self.releaseDate = releaseDate
  }
}
