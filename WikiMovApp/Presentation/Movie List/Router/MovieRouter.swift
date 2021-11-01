// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov

protocol MovieRouter {
  func showDetail(with movieId: Int)
}

final class DefaultMovieRouter: MovieRouter {
  
  private lazy var client: HTTPClient = {
    return URLSessionHTTPClient()
  }()
  
  private let view: MovieViewInput
  
  init(view: MovieViewInput) {
    self.view = view
  }
  
  func showDetail(with movieId: Int) {
    self.view.navigation?.pushViewController(makeDetailMovieController(movieId: movieId), animated: true)
  }
}

extension DefaultMovieRouter {
  private func makeDetailMovieController(movieId id: Int) -> MovieDetailViewController {
    
    let loader = DefaultMovieDetailLoader(client: client)
    let detail = MovieDetailViewController()
    let presenter = DefaultMovieDetailPresenter(loader: loader, view: detail)
    presenter.movieId.value = id
    
    detail.presenter = presenter
  
    return detail
  }
}
