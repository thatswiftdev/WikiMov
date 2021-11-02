// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieReviewDataSource: NSObject, UITableViewDataSourceDelegate {
  
  private var reviews: [ReviewViewModel]!
  
  init(reviews: [ReviewViewModel]) {
    super.init()
    self.reviews = reviews
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ReviewCell")
    cell.selectionStyle = .none
    cell.textLabel?.text = "From: " + reviews[indexPath.row].author
    cell.textLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    cell.detailTextLabel?.numberOfLines = 0
    cell.detailTextLabel?.text = reviews[indexPath.row].content
    
    return cell
  }
}
