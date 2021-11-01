// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit
import WikiMov

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  private lazy var client: HTTPClient = {
      URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
  }()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(frame: scene.coordinateSpace.bounds)
    window?.windowScene = scene
    window?.rootViewController = self.initialController()
    window?.makeKeyAndVisible()
  }
  
  private func makePresenter() -> MovieListPresenter {
    let loader = DefaultMovieLoader(client: client)
    let presenter = DefaultMovieListPresenter(loader: loader)
    return presenter
  }
  
  private func initialController() -> UINavigationController {
    let movieList = MovieListViewController(presenter: self.makePresenter())
    movieList.view.backgroundColor = .white
    
    let navigation = UINavigationController(rootViewController: movieList)
    return navigation
  }
}

