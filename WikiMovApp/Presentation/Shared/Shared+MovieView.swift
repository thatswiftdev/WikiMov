// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

class MovieView: UIView {
  
  private(set) lazy var container = UIView.make {
    $0.verticalPadding(to: self, 3)
    $0.horizontalPadding(to: self, 8)
    $0.backgroundColor = Constants.Color.white
    $0.layer.shadowColor = Constants.Color.black.withAlphaComponent(0.4).cgColor
    $0.layer.shadowOpacity = 0.7
    $0.layer.shadowOffset = .zero
    $0.layer.shadowRadius = 2
  }
  
  private(set) lazy var stack = UIStackView.make {
    $0.spacing = 10
    $0.edges(to: container, 5)
    $0.alignment = .top
  }
  
  private(set) lazy var posterView = RemoteImageView.make {
    $0.backgroundColor = .lightGray
    $0.contentMode = .scaleAspectFit
  }
  
  private(set) lazy var stackHeader = UIStackView.make {
    $0.axis = .vertical
    $0.spacing = 10
  }
  
  private(set) lazy var stackTitle = UIStackView.make {
    $0.distribution = .fill
  }
  
  private lazy var stackContent = UIStackView.make {
    $0.axis = .vertical
    $0.spacing = 10
  }
  
  private(set) lazy var titleLabel = UILabel.make {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.numberOfLines = 2
    $0.adjustsFontSizeToFitWidth = true
  }
  
  private(set) lazy var releaseDateLabel = UILabel.make {
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = .gray
    $0.numberOfLines = 1
  }
  
  private(set) lazy var overviewLabel = UILabel.make {
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
              stackTitle.addArrangedSubviews([titleLabel]),
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
