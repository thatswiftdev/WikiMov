// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

protocol MovieDetailPresenterUseCase {
  func addMovieToFavorite(_ movie: MovieViewModel)
  func removeMovieFromFavorite(_ movie: MovieViewModel)
  func loadMovieDetailFromLocalStore(movieId: Int)
  func loadMovieReviews(movieId: Int)
}

protocol MovieDetailPresenterInput {
  var movieId: Observable<Int?> { get }
  var movieDetail: Observable<MovieViewModel?> { get }
  var reviews: Observable<[ReviewViewModel]> { get }
  var reviewDataSource: Observable<MovieReviewDataSource?> { get }
}

protocol MovieDetailPresenter: MovieDetailPresenterUseCase, MovieDetailPresenterInput {}
