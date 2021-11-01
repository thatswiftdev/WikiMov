// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit
import WikiMov

class MovieListViewController: UIViewController, BarButtonAble {
  
  private var presenter: MovieListPresenter!
  
  private lazy var titleLabel = UILabel.make {
    $0.textColor = .black
    $0.text = "WikiMov"
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
  }
  
  convenience init(presenter: MovieListPresenter) {
    self.init()
    self.presenter = presenter
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBarButton()
  }

  // MARK: - Helpers
  private func configureBarButton() {
    makeBarButton(withCustomView: titleLabel, position: .leftBarButton)
    let rightBarButton = makeBarButton(withImage: UIImage(systemName: "heart.fill"), position: .rightBarButton)
    rightBarButton.tintColor = .systemPink
  }

}

