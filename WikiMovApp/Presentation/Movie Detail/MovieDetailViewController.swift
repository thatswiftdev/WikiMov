// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieDetailViewController: SharedView {
  
  var presenter: MovieDetailPresenter!
  
  private lazy var movieDetailView = MovieDetailView()
  private let reviewCellIdentifier = "ReviewCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    show(isLoading: true)
    configureViews()
    configureSubviews()
    configureCallbacks()
    configureObserver()
  }
  
  // MARK: -  Helpers
  private func configureViews() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reviewCellIdentifier)
    tableView.separatorStyle = .singleLine
    tableViewHeight = tableView.zeroHeightConstraint
    scrollView.edges(to: view, 0, true)
    configureBackBarButton()
  }
  
  private func configureSubviews() {
    view.backgroundColor = Constants.Color.white
    view.addSubviews([
      scrollView.addArrangedSubViews([
        movieDetailView,
        tableView
      ])
    ])
  }
  
  private func configureCallbacks() {
    movieDetailView.favoriteCallback = { [weak self] type in
      self?.fireHapticFeedBack()
      
      switch type {
      case let .addToFavorite(viewModel):
        self?.presenter.addMovieToFavorite(viewModel)
        
      case let .deleteFromFavorite(viewModel):
        self?.presenter.removeMovieFromFavorite(viewModel)
      }
    }
    
    scrollView.refreshCallback = { [weak self] in
      if let movieId = self?.presenter.movieId.value {
        self?.presenter.loadMovieDetailFromLocalStore(movieId: movieId)
        self?.presenter.loadMovieReviews(movieId: movieId)
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
  
  func fireHapticFeedBack() {
    self.impactGenerator(style: .medium)
  }
}
