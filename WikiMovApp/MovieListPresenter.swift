// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

protocol MovieListViewBehavior: BarButtonAble {}

protocol MovieListPresenterUseCase {
  func loadMovies(from endpoint: Endpoint)
}

protocol MovieListPresenter: MovieListPresenterUseCase {}


final class DefaultMovieListPresenter: MovieListPresenter {
  
  private let loader: MovieLoader
  private let view: MovieListViewBehavior
  
  init(loader: MovieLoader, view: MovieListViewBehavior) {
    self.loader = loader
    self.view = view
  }
  
  func loadMovies(from endpoint: Endpoint) {
    loader.load(from: endpoint) { result in
      switch result {
      case .success(let success):
        print(success)
      case .failure(let failure):
        print(failure)
      }
    }
  }
}
