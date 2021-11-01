// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit
import WikiMov

class MovieListViewController: UIViewController {
  
  private var presenter: MovieListPresenter!
  
  convenience init(presenter: MovieListPresenter) {
    self.init()
    self.presenter = presenter
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemPurple
    load()
  }

  func load() {
    self.presenter.loadMovies(from: MovieEndpoint.nowPlaying)
  }

}

