// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

protocol MovieDetailPresenterUseCase {
  func loadMovieDetail(id: Int)
  func loadMovieReviews(id: Int)
}

protocol MovieDetailPresenterInput {
  var movieId: Observable<Int> { get }
  var movieDetail: Observable<MovieViewModel?> { get }
}

protocol MovieDetailPresenter: MovieDetailPresenterUseCase, MovieDetailPresenterInput {}
