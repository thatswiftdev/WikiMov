// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieCell: UITableViewCell {
  
  static let identifier = String(describing: self)
  
  private(set) lazy var movieView = MovieView.make {
    $0.edges(to: contentView)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    contentView.addSubviews([
      movieView
    ])
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
