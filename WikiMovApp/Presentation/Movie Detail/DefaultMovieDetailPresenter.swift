// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

final class DefaultMovieDetailPresenter: MovieDetailPresenter {
  
  let movieId: Observable<Int?> = Observable(nil)
  let movieDetail: Observable<MovieViewModel?> = Observable(nil)
  
  private let remoteLoader: MovieDetailLoader
  private let localLoader: LocalMovieLoader
  private let view: MovieDetailViewBehavior
  
  init(loader: MovieDetailLoader, localLoader: LocalMovieLoader, view: MovieDetailViewBehavior) {
    self.remoteLoader = loader
    self.localLoader = localLoader
    self.view = view
    
    configureObservers()
  }
  
  private func configureObservers() {
    configureMovieIdObserver()
    configureMovieDetailObserver()
  }
  
  private func configureMovieIdObserver() {
    self.movieId.observe(on: self) { [weak self] id in
      guard let self = self, let id = id else { return }
      self.loadMovieDetailFromLocalStore(movieId: id)
    }
  }
  
  private func configureMovieDetailObserver() {
    self.movieDetail.observe(on: self) { [weak self] detail in
      guard let self = self else { return }
      
      if let detail = detail {
        self.view.configureView(with: detail)
      } else if let id = self.movieId.value {
        self.loadMovieDetailFromRemote(movieId: id)
      }
    }
  }
  
  func loadMovieDetailFromLocalStore(movieId: Int) {
    localLoader.load { result in
      switch result {
      case let .success(movies):
        
        let movie = movies.toViewModels().filter { $0.id == movieId }.first
        self.movieDetail.value = movie
        
      case .failure:
        self.movieDetail.value = nil
      }
    }
  }
  
  private func loadMovieDetailFromRemote(movieId: Int) {
    remoteLoader.load(from: MovieDetailEndpoint.detail(id: movieId)) { result in
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
  
  func loadMovieReviews(movieId: Int) {
    //
  }
  
  func addMovieToFavorite(_ movie: MovieViewModel) {
    localLoader.save(movie.toLocal()) { error in
      if error == nil {
        self.loadMovieDetailFromLocalStore(movieId: movie.id)
      }
    }
  }
}

private extension MovieViewModel {
  func toLocal() -> LocalMovie {
    return LocalMovie(id: id, title: title, backdropPath: backdropPath, posterPath: posterPath, releaseDate: releaseDate, overview: overview, isFavorite: isFavorite)
  }
}

private extension Array where Element == LocalMovie {
  func toViewModels() -> [MovieViewModel] {
    return map { MovieViewModel(id: $0.id, title: $0.title, backdropPath: $0.backdropPath, posterPath: $0.posterPath, releaseDate: $0.releaseDate, overview: $0.overview, isFavorite: $0.isFavorite) }
  }
}
