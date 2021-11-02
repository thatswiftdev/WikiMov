// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class FavoriteMoviesViewController: SharedView {
  
  var presenter: FavoriteMoviePresenter!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    configureSubviews()
    load()
  }
  
  // MARK: - Helpers
  private func load() {
    self.show(isLoading: true)
    self.presenter.loadFavoritedMovies()
    self.presenter.dataSource.observe(on: self) { [weak self] dataSource in
      guard let self = self, let dataSource = dataSource else { return }
      self.tableView.dataSourceDelegate(dataSource).reloads()
    }
  }
  
  private func configureViews() {
    view.backgroundColor = .white
    view.addSubviews([
      scrollView.addArrangedSubViews([tableView]),
    ])
  }
  
  private func configureSubviews() {
    tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
    tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
    scrollView.edges(to: view, 0, true)
  }
}

extension FavoriteMoviesViewController: FavoriteMovieViewBehavior {
  
  var navigation: UINavigationController? {
    return self.navigationController
  }
  
  func setTitle(_ title: String) {
    self.title = title
  }
  
  func show(isLoading: Bool) {
    if isLoading {
      self.scrollView.refreshControl?.beginRefreshing()
    } else {
      self.scrollView.refreshControl?.endRefreshing()
    }
  }
}
