// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

class MovieDetailView: MovieView {
  
  var favoriteCallback: ((CallbackType) -> Void)?
  
  enum CallbackType {
    case addToFavorite(MovieViewModel)
    case deleteFromFavorite(MovieViewModel)
  }
  
  private var viewModel: MovieViewModel?
  
  private lazy var favoriteButton = UIButton.make {
    $0.width(35)
    $0.height(30)
    $0.top(to: container, 5)
    $0.trailing(to: container, 5)
    $0.setBackgroundImage(Constants.Image.unfavorite, for: .normal)
    $0.setBackgroundImage(Constants.Image.favorite, for: .selected)
    $0.tintColor = Constants.Color.pink
    $0.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    posterView.width(160)
    posterView.height(250)
    overviewLabel.numberOfLines = 0
    
    addCustomConstraints([
      .spacing(from: titleLabel, .trailing(false), relation: .equal, to: favoriteButton, .leading(false), constant: 10)
    ])
  }
  
  func configure(with viewModel: MovieViewModel) {
    self.viewModel = viewModel
    
    titleLabel.text = viewModel.title
    releaseDateLabel.text = viewModel.formattedReleaseDate
    overviewLabel.text = viewModel.overview
    posterView.setImage(from: viewModel.posterPath)
    favoriteButton.isSelected = viewModel.isFavorite
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  // MARK: - Events
  @objc private func favButtonAction() {
    if let vm = self.viewModel {
      if favoriteButton.isSelected {
        self.favoriteCallback?(.deleteFromFavorite(vm))
      } else {
        self.favoriteCallback?(.addToFavorite(vm))
      }
    }
  }
}
