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
    
    let store = try! CoreDataLocalMovieStore(storeURL: URL.storeURL())
    let remoteLoader = DefaultMovieDetailLoader(client: client)
    let localLoader = DefaultLocalMovieLoader(store: store)
    let detail = MovieDetailViewController()
    let presenter = DefaultMovieDetailPresenter(loader: remoteLoader, localLoader: localLoader, view: detail)
    presenter.movieId.value = id
    
    detail.presenter = presenter
  
    return detail
  }
}


private extension URL {
  static func storeURL() -> URL {
    let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    return url.appendingPathComponent("\(type(of: CoreDataLocalMovieStore.self))")
  }
}
