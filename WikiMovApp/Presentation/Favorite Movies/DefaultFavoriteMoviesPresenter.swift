// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

final class DefaultFavoriteMoviesPresenter: FavoriteMoviePresenter {
  
  let localMovie: Observable<[MovieViewModel]> = Observable([])
  let dataSource: Observable<MovieDataSource?> = Observable(nil)
  
  private let loader: LocalMovieLoader
  private let view: FavoriteMovieViewBehavior
  private let router: MovieRouter
  
  init(loader: LocalMovieLoader, view: FavoriteMovieViewBehavior, router: MovieRouter) {
    self.loader = loader
    self.view = view
    self.router = router
    
    configureObservers()
  }
  
  private func configureObservers() {
    let dataSource = dataSource
    self.localMovie.observe(on: self) { movies in
      dataSource.value = MovieDataSource(movies: movies)
      dataSource.value?.selectedCallback = { [weak self] id in
        self?.router.showDetail(with: id)
      }
    }
  }
  
  func loadFavoritedMovies() {
    loader.load { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case let .success(data):
        
        self.localMovie.value = data.toViewModel()
        
        DispatchQueue.main.async {
          self.view.show(isLoading: false)
        }
        
      case .failure:
        break
      }
    }
  }
}
