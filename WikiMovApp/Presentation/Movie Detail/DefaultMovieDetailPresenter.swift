// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

final class DefaultMovieDetailPresenter: MovieDetailPresenter {
  
  let movieId: Observable<Int> = Observable(0)
  let movieDetail: Observable<MovieViewModel?> = Observable(nil)
  
  private let loader: MovieDetailLoader
  private let view: MovieDetailViewBehavior
  
  init(loader: MovieDetailLoader, view: MovieDetailViewBehavior) {
    self.loader = loader
    self.view = view
    
    configureObservers()
  }
  
  private func configureObservers() {
    self.movieId.observe(on: self) { [weak self] id in
      guard let self = self, id != 0 else { return }
      self.loadMovieDetail(id: id)
    }
    
    self.movieDetail.observe(on: self) { [weak self] detail in
      guard let self = self, let detail = detail else { return }
      self.view.configureView(with: detail)
    }
  }
  
  func loadMovieDetail(id: Int) {
    loader.load(from: MovieDetailEndpoint.detail(id: id)) { result in
      switch result {
      case let .success(detail):
        
        let viewModel = MovieViewModel(
          id: detail.id ?? 0,
          title: detail.title ?? "",
          backdropPath: detail.backdrop_path ?? "",
          posterPath: detail.poster_path ?? "",
          releaseDate: detail.release_date ?? "",
          overview: detail.overview ?? "",
          isFavorite: false
        )
        
        self.movieDetail.value = viewModel
        
      case .failure:
        break
      }
    }
  }
  
  func loadMovieReviews(id: Int) {
    //
  }
}
