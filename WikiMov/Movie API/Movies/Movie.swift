// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public struct Movie: Decodable {
  public let id: Int?
  public let title: String?
  public let backdrop_path: String?
  public let poster_path: String?
  public let release_date: String?
  public let overview: String?
  
  public init(
    id: Int?,
    title: String?,
    backdropPath: String?,
    posterPath: String?,
    releaseDate: String?,
    overview: String?)
  {
    self.id = id
    self.title = title
    self.backdrop_path = backdropPath
    self.poster_path = posterPath
    self.release_date = releaseDate
    self.overview = overview
  }
}
