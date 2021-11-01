// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

struct MovieViewModel {
  public let id: Int
  public let title: String
  public let backdropPath: String
  public let posterPath: String
  public let releaseDate: String
  public let overview: String
  public let isFavorite: Bool
}

extension MovieViewModel {
  var formattedReleaseDate: String {
    return releaseDate.formatDate(from: .serverDate, to: .dayMonthYear)
  }
}
