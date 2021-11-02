// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieDetailViewController: UIViewController {
  
  var presenter: MovieDetailPresenter!
  
  private lazy var movieDetailView = MovieDetailView()
  
  private var tableViewHeight: NSLayoutConstraint? {
    didSet { tableViewHeight?.activated() }
  }
  
  private lazy var scrollView = ScrollViewContainer.make {
    $0.edges(to: view, 0, true)
    $0.setBackgroundColor(color: .white)
    $0.setSpacingBetweenItems(to: 5)
  }
  
  private lazy var tableView = UITableView.make {
    $0.separatorStyle = .none
    $0.rowHeight = UITableView.automaticDimension
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "ReviewCell")
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    show(isLoading: true)
    configureSubviews()
    configureCallbacks()
    configureObserver()
  }
  
  // MARK: -  Helpers
  private func configureSubviews() {
    view.backgroundColor = .white
    tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
    view.addSubviews([
      scrollView.addArrangedSubViews([
        movieDetailView,
        tableView
      ])
    ])
  }
  
  private func updateTableViewContentSize(size: CGFloat) {
    DispatchQueue.main.async {
      self.tableViewHeight?.constant = size
      self.view.layoutIfNeeded()
    }
  }
  
  private func configureCallbacks() {
    movieDetailView.favoriteCallback = { [weak self] type in
      switch type {
      case let .addToFavorite(viewModel):
        self?.presenter.addMovieToFavorite(viewModel)
        
      case let .deleteFromFavorite(viewModel):
        self?.presenter.removeMovieFromFavorite(viewModel)
      }
    }
  }
  
  private func configureObserver() {
    self.presenter.reviewDataSource.observe(on: self) { [weak self] dataSource in
      guard let self = self, let dataSource = dataSource else { return }
      self.tableView.dataSourceDelegate(dataSource).reloads()
    }
  }
}

extension MovieDetailViewController: MovieDetailViewBehavior {
  func configureView(with viewModel: MovieViewModel) {
    title = viewModel.title
    movieDetailView.configure(with: viewModel)
    show(isLoading: false)
  }
  
  func show(isLoading: Bool) {
    if isLoading {
      self.scrollView.refreshControl?.beginRefreshing()
    } else  {
      self.scrollView.refreshControl?.endRefreshing()
    }
  }
}
