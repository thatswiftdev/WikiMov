// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public struct LocalMovie: Hashable {
  
  public let id: Int
  public let title: String
  public let backdropPath: String
  public let posterPath: String
  public let releaseDate: String
  public let overview: String
  public let isFavorite: Bool
  
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
