// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

protocol FavoriteMoviePresenterUseCase {
  func loadFavoritedMovies()
}

protocol FavoriteMoviePresenter: FavoriteMoviePresenterUseCase {}

final class DefaultFavoriteMoviePresenter: FavoriteMoviePresenter {
  
  private let loader: LocalMovieLoader
  
  init(loader: LocalMovieLoader) {
    self.loader = loader
  }
  
  func loadFavoritedMovies() {
    loader.load { result in
      
      switch result {
      case let .success(data):
        dump(data)
        
      case .failure:
        break
      }
    }
  }
}
