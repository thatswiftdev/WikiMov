// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

final class DefaultMovieListPresenter: MovieListPresenter {
  
  let localMovie: Observable<[MovieViewModel]> = Observable([])
  let dataSource: Observable<MovieDataSource?> = Observable(nil)
  
  private let loader: MovieLoader
  private let view: MovieListViewBehavior
  private let router: MovieRouter
  
  init(loader: MovieLoader, view: MovieListViewBehavior, router: MovieRouter) {
    self.loader = loader
    self.view = view
    self.router = router
    
    configureObservers()
  }
  
  private func configureObservers() {
    self.localMovie.observe(on: self) { [weak self] movies in
      guard let self = self else { return }
      
      self.dataSource.value = MovieDataSource(movies: movies)
      self.dataSource.value?.selectedCallback = { [weak self] id in
        self?.router.showDetail(with: id)
      }
    }
  }
  
  func loadFavoriteMovies() {
    self.router.showFavorites()
  }
  
  func loadMovies(from endpoint: Endpoint) {
    loader.load(from: endpoint) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case let .success(movies):
  
        self.localMovie.value = movies.toViewModel()
        self.view.show(isLoading: false)
        
      case .failure:
        self.view.show(isLoading: false)
      }
    }
  }
}
