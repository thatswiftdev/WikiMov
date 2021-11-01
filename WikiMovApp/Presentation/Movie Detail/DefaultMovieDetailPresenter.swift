// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

final class DefaultMovieDetailPresenter: MovieDetailPresenter {
  
  let movieId: Observable<Int> = Observable(0)
  let movieDetail: Observable<MovieViewModel?> = Observable(nil)
  
  private let loader: MovieDetailLoader

  init(loader: MovieDetailLoader) {
    self.loader = loader
    
    configureObservers()
  }
  
  private func configureObservers() {
    self.movieId.observe(on: self) { [weak self] id in
      guard let self = self, id != 0 else { return }
      self.loadMovieDetail(id: id)
    }
    
    self.movieDetail.observe(on: self) { [weak self] detail in
      //
    }
  }
  
  func loadMovieDetail(id: Int) {
    loader.load(from: MovieDetailEndpoint.detail(id: id)) { result in
      switch result {
      case let .success(detail):
        dump(detail)
        
      case .failure:
        break
      }
    }
  }
  
  func loadMovieReviews(id: Int) {
    //
  }
}
