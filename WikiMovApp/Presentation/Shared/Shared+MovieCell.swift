// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieCell: UITableViewCell {
  
  static let identifier = String(describing: self)
  
  private(set) lazy var movieView = MovieView.make {
    $0.edges(to: contentView)
    $0.overviewLabel.numberOfLines = 3
    $0.posterView.width(100)
    $0.posterView.height(140)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = Constants.Color.white
    selectionStyle = .none
    contentView.addSubviews([
      movieView
    ])
  }
  
  func configure(with viewModel: MovieViewModel) {
    movieView.titleLabel.text = viewModel.title
    movieView.releaseDateLabel.text = viewModel.formattedReleaseDate
    movieView.overviewLabel.text = viewModel.overview
    movieView.posterView.setImage(from: viewModel.posterPath)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
