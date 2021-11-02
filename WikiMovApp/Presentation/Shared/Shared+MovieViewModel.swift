// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

struct MovieViewModel {
  let id: Int
  let title: String
  let backdropPath: String
  let posterPath: String
  let releaseDate: String
  let overview: String
  let isFavorite: Bool
}

extension MovieViewModel {
  var formattedReleaseDate: String {
    return releaseDate.formatDate(from: .serverDate, to: .dayMonthYear)
  }
}
