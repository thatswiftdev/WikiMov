// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

final class MovieDataSource: NSObject, UITableViewDataSourceDelegate {
  
  typealias MovieID = Int
  
  var selectedCallback: ((MovieID) -> Void)?
  
  private var movies: [MovieViewModel]!
  
  init(movies: [MovieViewModel]) {
    super.init()
    self.movies = movies
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard  let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
      return UITableViewCell()
    }
    cell.configure(with: movies[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedCallback?(movies[indexPath.row].id)
  }
}
