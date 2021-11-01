// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

protocol MovieDetailPresenterUseCase {
  func loadMovieDetail(id: Int)
}

protocol MovieDetailPresenterInput {
  var movieId: Observable<Int> { get }
}

protocol MovieDetailPresenter: MovieDetailPresenterUseCase, MovieDetailPresenterInput {}
