// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieDetailViewController: UIViewController {
  
  private lazy var movieView = MovieDetailView.make {
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
  }
  
  // MARK: -  Helpers
  private func configureSubviews() {
    view.backgroundColor = .white
    view.addSubviews([
      scrollView.addArrangedSubViews([
        movieView
      ])
    ])
  }

}

extension MovieDetailViewController: MovieDetailViewBehavior {
  func configureView(with viewModel: MovieViewModel) {
    title = viewModel.title
    movieView.titleLabel.text = viewModel.title
    movieView.releaseDateLabel.text = viewModel.formattedReleaseDate
    movieView.overviewLabel.text = viewModel.overview
    movieView.posterView.setImage(from: viewModel.posterPath)
  }
}
