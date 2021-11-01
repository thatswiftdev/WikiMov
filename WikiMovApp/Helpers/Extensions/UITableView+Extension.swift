// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

typealias UITableViewDataSourceDelegate = UITableViewDataSource & UITableViewDelegate

extension UITableView {
  
  static let contentSizeKeyPath = "contentSize"
  
  func reloads() {
    DispatchQueue.main.async {
      self.reloadData()
    }
  }
  
  @discardableResult
  func dataSourceDelegate(_ sourceDelegate: UITableViewDataSourceDelegate) -> Self {
    self.delegate = sourceDelegate
    self.dataSource = sourceDelegate
    return self
  }
}
