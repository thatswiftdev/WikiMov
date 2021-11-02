// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class FavoriteMoviesViewController: SharedView {
  
  var presenter: FavoriteMoviePresenter!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSubviews()
    load()
  }
  
  // MARK: - Helpers
  private func load() {
    self.presenter.loadFavoritedMovies()
  }
  
  private func configureSubviews() {
    tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
    view.backgroundColor = .white
    view.addSubviews([
      scrollView.addArrangedSubViews([tableView]),
    ])
  }
}

