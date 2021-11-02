// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

final class DefaultMovieDetailPresenter: MovieDetailPresenter {
  
  let movieId: Observable<Int?> = Observable(nil)
  let movieDetail: Observable<MovieViewModel?> = Observable(nil)
  let reviews: Observable<[ReviewViewModel]> = Observable([])
  let reviewDataSource: Observable<MovieReviewDataSource?> = Observable(nil)
  
  private let adapter: MovieDetailAdapter
  private let reviewLoader: ReviewLoader
  private let view: MovieDetailViewBehavior
 
  
  init(adapter: MovieDetailAdapter, reviewLoader: ReviewLoader, view: MovieDetailViewBehavior) {
    self.adapter = adapter
    self.reviewLoader = reviewLoader
    self.view = view
    
    configureObservers()
  }
  
  struct MovieDetailAdapter {
    let remoteLoader: MovieDetailLoader
    let localLoader: LocalMovieLoader
  }
  
  private func configureObservers() {
    configureMovieIdObserver()
    configureMovieDetailObserver()
    configureReviewsObserver()
  }
  
  private func configureMovieIdObserver() {
    self.movieId.observe(on: self) { [weak self] id in
      guard let self = self, let id = id else { return }
      self.loadMovieDetailFromLocalStore(movieId: id)
      self.loadMovieReviews(movieId: id)
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
  
  private func configureReviewsObserver() {
    let dataSource = reviewDataSource
    self.reviews.observe(on: self) { reviews in
      dataSource.value = MovieReviewDataSource(reviews: reviews)
    }
  }
  
  func loadMovieDetailFromLocalStore(movieId: Int) {
    adapter.localLoader.load { result in
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
    adapter.remoteLoader.load(from: MovieDetailEndpoint.detail(id: movieId)) { result in
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
    reviewLoader.load(from: MovieReviewsEndpoint.reviews(movieId: movieId)) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case let .success(reviews):
        self.reviews.value = reviews.toViewModel()
        
      case .failure:
        break
      }
    }
  }
  
  func addMovieToFavorite(_ movie: MovieViewModel) {
    adapter.localLoader.save(movie.toLocal()) { [weak self] error in
      if error == nil {
        self?.loadMovieDetailFromLocalStore(movieId: movie.id)
      }
    }
  }
  
  func removeMovieFromFavorite(_ movie: MovieViewModel) {
    adapter.localLoader.delete(movie.toLocal()) { [weak self] error in
      if error == nil {
        self?.loadMovieDetailFromLocalStore(movieId: movie.id)
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

private extension Array where Element == Review {
  func toViewModel() -> [ReviewViewModel] {
    return map { ReviewViewModel(id: $0.id ?? "0", author: $0.author ?? "", content: $0.content ?? "")}
  }
}
