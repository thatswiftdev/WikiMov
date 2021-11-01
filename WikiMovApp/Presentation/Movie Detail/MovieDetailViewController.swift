// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieDetailViewController: UIViewController {
  
  private lazy var movieDetailView = MovieDetailView.make {
    $0.posterView.width(160)
    $0.posterView.height(220)
    $0.overviewLabel.numberOfLines = 0
  }
  
  private lazy var scrollView = ScrollViewContainer.make {
    $0.edges(to: view, 0, true)
    $0.setBackgroundColor(color: .white)
    $0.setSpacingBetweenItems(to: 5)
  }
  
  var presenter: MovieDetailPresenter!
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    movieDetailView.favoriteCallback = { [weak self] viewModel in
      self?.presenter.addMovieToFavorite(viewModel)
    }
  }

}

extension MovieDetailViewController: MovieDetailViewBehavior {
  func configureView(with viewModel: MovieViewModel) {
    title = viewModel.title
    movieDetailView.configure(with: viewModel)
  }
}
