// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public struct LocalMovie: Hashable {
  let id: Int
  let title: String
  let backdropPath: String
  let posterPath: String
  let releaseDate: String
  let overview: String
  let isFavorite: Bool
  
  public init(
    id: Int,
    title: String,
    backdropPath: String,
    posterPath: String,
    releaseDate: String,
    overview: String,
    isFavorite: Bool
  )
  {
    self.id = id
    self.title = title
    self.backdropPath = backdropPath
    self.posterPath = posterPath
    self.releaseDate = releaseDate
    self.overview = overview
    self.isFavorite = isFavorite
  }
}
