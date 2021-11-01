// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieView: UIView {
  
  private lazy var container = UIView.make {
    $0.verticalPadding(to: self, 3)
    $0.horizontalPadding(to: self, 8)
    $0.backgroundColor = .white
    $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
    $0.layer.shadowOpacity = 0.7
    $0.layer.shadowOffset = .zero
    $0.layer.shadowRadius = 2
  }
  
  private lazy var stack = UIStackView.make {
    $0.spacing = 10
    $0.edges(to: container, 5)
  }
  
  private lazy var posterView = UIImageView.make {
    $0.backgroundColor = .red
    $0.contentMode = .scaleAspectFit
    $0.width(100)
    $0.height(140)
  }
  
  private lazy var stackHeader = UIStackView.make {
    $0.axis = .vertical
  }
  
  private lazy var stackContent = UIStackView.make {
    $0.axis = .vertical
    $0.distribution = .fillProportionally
  }
  
  private lazy var titleLabel = UILabel.make {
    $0.text = "Title 1"
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.numberOfLines = 2
  }
  
  private lazy var releaseDateLabel = UILabel.make {
    $0.text = "20 September 2021"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = .gray
    $0.numberOfLines = 1
  }
  
  private lazy var overviewLabel = UILabel.make {
    $0.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
    $0.numberOfLines = 3
    $0.font = .systemFont(ofSize: 14, weight: .light)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubviews([
      container.addSubviews([
        stack.addArrangedSubviews([
          posterView,
          stackContent.addArrangedSubviews([
            stackHeader.addArrangedSubviews([
              titleLabel,
              releaseDateLabel
            ]),
            overviewLabel
          ])
        ])
      ])
    ])
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

final class MovieCell: UITableViewCell {
  
  static let identifier = String(describing: self)
  
  private lazy var movieView = MovieView.make {
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
