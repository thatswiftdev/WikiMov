// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

protocol FavoriteMoviePresenterUseCase {
  func loadFavoritedMovies()
}

protocol FavoriteMoviePresenter: MovieListPresenterOutput, FavoriteMoviePresenterUseCase {}
