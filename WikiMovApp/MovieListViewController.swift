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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBarButton()
  }

  // MARK: - Helpers
  private func load() {
    self.presenter.loadMovies(from: MovieEndpoint.popular)
  }
  
  private func configureBarButton() {
    makeBarButton(withCustomView: titleLabel, position: .leftBarButton)
    let rightBarButton = makeBarButton(withImage: Constants.Image.favorite, position: .rightBarButton)
    rightBarButton.tintColor = Constants.Color.pink
  }

}

extension MovieListViewController: MovieListViewBehavior {}
