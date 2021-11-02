// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

protocol Alertable {
  typealias AlertAction = () -> Void
}

extension Alertable where Self: UIViewController {
  
  private func makeAlertController(title: String? = nil, message: String? = nil, style: UIAlertController.Style) -> UIAlertController {
    return UIAlertController(title: title, message: message, preferredStyle: style)
  }
  
  func showCategoryAlert(upcoming firstHandler: @escaping AlertAction, popular secondHandler: @escaping AlertAction, topRated thirdHandler: @escaping AlertAction, nowPlaying fourthHandler: @escaping AlertAction) {
    
    let alert = makeAlertController(title: "Find Movies by Category", style: .actionSheet)
    
    let upcoming = UIAlertAction(title: "Upcoming", style: .default) { _ in
      firstHandler()
    }
    
    let popular = UIAlertAction(title: "Popular", style: .default) { _ in
      secondHandler()
    }
    
    let topRated = UIAlertAction(title: "Top Rated", style: .default) { _ in
      thirdHandler()
    }
    
    let nowPlaying = UIAlertAction(title: "Now Playing", style: .default) { _ in
      fourthHandler()
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .destructive)
    
    alert.addAction(upcoming)
    alert.addAction(popular)
    alert.addAction(topRated)
    alert.addAction(nowPlaying)
    alert.addAction(cancel)
    
    present(alert, animated: true)
  }
}

