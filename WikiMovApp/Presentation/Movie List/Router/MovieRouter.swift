// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import WikiMov
import UIKit

protocol MovieRouter {
  func showDetail(with movieId: Int)
  func showFavorites()
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
    navigate(to: makeDetailMovieController(movieId: movieId))
  }
  
  func showFavorites() {
    navigate(to: makeFavoriteMoviesController())
  }
}

extension DefaultMovieRouter {
  
  private func navigate(to viewController: UIViewController) {
    self.view.navigation?.pushViewController(viewController, animated: true)
  }
  
  private func makeFavoriteMoviesController() -> FavoriteMoviesViewController {
    let favorite = FavoriteMoviesViewController()
    let presenter = DefaultFavoriteMoviePresenter(loader: makeLocalMovieLoader())
    
    favorite.presenter = presenter
    return favorite
  }
  
  private func makeDetailMovieController(movieId id: Int) -> MovieDetailViewController {
    
    let localLoader = makeLocalMovieLoader()
    let remoteLoader = DefaultMovieDetailLoader(client: client)
    let reviewLoader = DefaultReviewLoader(client: client)
    
    let detail = MovieDetailViewController()
    
    let presenter = DefaultMovieDetailPresenter(adapter: DefaultMovieDetailPresenter.MovieDetailAdapter(remoteLoader: remoteLoader, localLoader: localLoader), reviewLoader: reviewLoader, view: detail)
    
    presenter.movieId.value = id
    detail.presenter = presenter
  
    return detail
  }
}

extension DefaultMovieRouter {
  private func makeLocalMovieLoader() -> LocalMovieLoader {
    let store = try! CoreDataLocalMovieStore(storeURL: URL.storeURL())
    let localLoader = DefaultLocalMovieLoader(store: store)
    return localLoader
  }
}


private extension URL {
  static func storeURL() -> URL {
    let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    return url.appendingPathComponent("\(type(of: CoreDataLocalMovieStore.self))")
  }
}
