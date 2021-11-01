// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

class MovieDetailView: MovieView {
  
  private lazy var favoriteButton = UIButton.make {
    $0.dimension(30)
    $0.backgroundColor = .red
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    stack.addArrangedSubview(favoriteButton)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
