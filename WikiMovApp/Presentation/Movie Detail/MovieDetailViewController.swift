// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieDetailViewController: UIViewController {
  
  var presenter: MovieDetailPresenter!
  
  private lazy var movieDetailView = MovieDetailView()
  
  private lazy var scrollView = ScrollViewContainer.make {
    $0.edges(to: view, 0, true)
    $0.setBackgroundColor(color: .white)
    $0.setSpacingBetweenItems(to: 5)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    show(isLoading: true)
    configureSubviews()
    configureCallbacks()
  }

  // MARK: -  Helpers
  private func configureSubviews() {
    view.backgroundColor = .white
    view.addSubviews([
      scrollView.addArrangedSubViews([
        movieDetailView
      ])
    ])
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
