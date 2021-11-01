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
    let datasource = dataSource
    
    self.localMovie.observe(on: self) { movies in
      datasource.value = MovieDataSource(movies: movies)
      datasource.value?.selectedCallback = { [weak self] id in
        guard let self = self else { return }
        self.router.showDetail(with: id)
      }
    }
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

private extension Array where Element == LocalMovie {
  func toViewModel() -> [MovieViewModel] {
    return map { MovieViewModel(
      id: $0.id,
      title: $0.title,
      backdropPath: $0.backdropPath,
      posterPath: $0.posterPath,
      releaseDate: $0.releaseDate,
      overview: $0.overview,
      isFavorite: $0.isFavorite)
    }
  }
}
