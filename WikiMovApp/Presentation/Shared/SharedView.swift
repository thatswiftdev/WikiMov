// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

class SharedView: UIViewController, Animatable {
  
  var tableViewHeight: NSLayoutConstraint? {
    didSet { tableViewHeight?.activated() }
  }
  
  private(set) lazy var scrollView = ScrollViewContainer.make {
    $0.setBackgroundColor(color: .white)
    $0.setSpacingBetweenItems(to: 5)
  }
  
  private(set) lazy var tableView = UITableView.make {
    $0.separatorStyle = .none
    $0.rowHeight = UITableView.automaticDimension
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.addObserver(self, forKeyPath: UITableView.contentSizeKeyPath, options: .new, context: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.removeObserver(self, forKeyPath: UITableView.contentSizeKeyPath)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if let newvalue = change?[.newKey], keyPath == UITableView.contentSizeKeyPath {
      if let newsize  = newvalue as?  CGSize {
        self.updateTableViewContentSize(animateView: tableView, size: newsize.height)
      }
    }
  }
  
  private func updateTableViewContentSize(animateView: UIView, size: CGFloat) {
    animate(with: animateView) {
      self.tableViewHeight?.constant = size
      self.view.layoutIfNeeded()
    } completion: { _ in }
  }
}
