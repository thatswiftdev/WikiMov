// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class FavoriteMoviesViewController: UIViewController, Animatable {
  
  var presenter: FavoriteMoviePresenter!
  
  private var tableViewHeight: NSLayoutConstraint? {
    didSet { tableViewHeight?.activated() }
  }
  
  private lazy var scrollView = ScrollViewContainer.make {
    $0.edges(to: view, 0, true)
    $0.horizontalPadding(to: view)
    $0.setBackgroundColor(color: .white)
    $0.setSpacingBetweenItems(to: 5)
  }
  
  
  private lazy var tableView = UITableView.make {
    $0.separatorStyle = .none
    $0.rowHeight = UITableView.automaticDimension
    $0.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSubviews()
    load()
  }
 
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.addObserver(self, forKeyPath: UITableView.contentSizeKeyPath, options: .new, context: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.removeObserver(self, forKeyPath: UITableView.contentSizeKeyPath)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if let newvalue = change?[.newKey], keyPath == UITableView.contentSizeKeyPath {
      if let newsize  = newvalue as?  CGSize {
        self.updateTableViewContentSize(size: newsize.height)
      }
    }
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
  
  private func updateTableViewContentSize(size: CGFloat) {
    animate(with: tableView) {
      self.tableViewHeight?.constant = size
      self.view.layoutIfNeeded()
    } completion: { _ in }
  }
}

