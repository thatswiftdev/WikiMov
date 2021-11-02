// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

protocol MovieListPresenterUseCase {
  func loadMovies(from endpoint: Endpoint)
  func loadFavoriteMovies()
}

protocol MovieListPresenter: MovieListPresenterUseCase, MovieListPresenterOutput {}
