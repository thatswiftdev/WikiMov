// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieDetailViewController: UIViewController {
  
  private var presenter: MovieDetailPresenter!
  
  convenience init(presenter: MovieDetailPresenter) {
    self.init()
    self.presenter = presenter
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemRed
  }
}
