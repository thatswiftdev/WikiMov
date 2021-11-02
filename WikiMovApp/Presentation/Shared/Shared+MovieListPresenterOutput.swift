// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

protocol MovieListPresenterOutput {
  var localMovie: Observable<[MovieViewModel]> { get }
  var dataSource: Observable<MovieDataSource?> { get }
}
