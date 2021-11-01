// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

protocol MovieListViewBehavior: BarButtonAble, Animatable {
  func show(isLoading: Bool)
}

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
    loader.load(from: endpoint) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case let .success(data):
        dump(data)
        self.view.show(isLoading: false)
        
      case .failure:
        self.view.show(isLoading: false)
      }
    }
  }
}
