// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import WikiMov

extension Array where Element == LocalMovie {
  func toViewModel() -> [MovieViewModel] {
    return map { MovieViewModel(
      id: $0.id,
      title: $0.title,
      backdropPath: $0.backdropPath,
      posterPath: $0.posterPath,
      releaseDate: $0.releaseDate,
      overview: $0.overview,
      isFavorite: $0.isFavorite)
    }
  }
}
