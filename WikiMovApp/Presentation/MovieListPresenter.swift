// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

protocol MovieListPresenterUseCase {
  func loadMovies(from endpoint: Endpoint)
}

protocol MovieListPresenterOutput {
  var localMovie: Observable<[MovieViewModel]> { get }
  var dataSource: Observable<MovieDataSource?> { get }
}

protocol MovieListPresenter: MovieListPresenterUseCase, MovieListPresenterOutput {}
