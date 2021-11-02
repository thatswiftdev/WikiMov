// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

public final class ScrollViewContainer: UIScrollView {
  
  private let refresher = UIRefreshControl()
  
  var refreshCallback: (() -> Void)?
  
  private lazy var stackView = UIStackView.make {
    $0.axis = .vertical
    $0.edges(to: self).center(.horizontal, to: self)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
    self.refreshControl = refresher
    addSubviews([stackView])
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  @discardableResult
  public func addArrangedSubViews(_ views: [UIView]) -> Self {
    self.stackView.addArrangedSubviews(views)
    return self
  }
  
  @discardableResult
  public func addArrangedSubViewToFirstIndex(_ view: UIView) -> Self {
    self.stackView.insertSubview(view, at: 0)
    return self
  }
  
  @discardableResult
  public func setSpacingBetweenItems(to value: CGFloat) -> Self {
    self.stackView.spacing = value
    return self
  }
  
  @discardableResult
  public func setBackgroundColor(color: UIColor?) -> Self {
    self.backgroundColor = color
    return self
  }
  
  @discardableResult
  public func showsVerticalScrollIndicator(_ isShow: Bool) -> Self {
    self.showsVerticalScrollIndicator = isShow
    return self
  }
  
  @objc private func refresh() {
    self.refreshCallback?()
  }
}
