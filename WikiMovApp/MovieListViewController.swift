// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit
import WikiMov

class MovieListViewController: UIViewController {
  
  var presenter: MovieListPresenter! {
    didSet { load() }
  }
  
  private lazy var titleLabel = UILabel.make {
    $0.textColor = .black
    $0.text = Constants.App.title
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
  }
  
  private lazy var scrollView = ScrollViewContainer.make {
    $0.edges(to: view, 0, true)
    $0.setBackgroundColor(color: .systemBlue)
    $0.setSpacingBetweenItems(to: 5)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSubviews()
    configureBarButton()
  }

  // MARK: - Helpers
  private func load() {
    self.presenter.loadMovies(from: MovieEndpoint.popular)
  }
  
  private func configureSubviews() {
    view.addSubviews([
      scrollView
    ])
  }
  
  private func configureBarButton() {
    makeBarButton(withCustomView: titleLabel, position: .leftBarButton)
    let rightBarButton = makeBarButton(withImage: Constants.Image.favorite, position: .rightBarButton)
    rightBarButton.tintColor = Constants.Color.pink
  }

}

extension MovieListViewController: MovieListViewBehavior {}
