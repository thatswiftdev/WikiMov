// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

protocol BarButtonAble {}

extension UIViewController {
  enum BarButtonPosition {
    case rightBarButton
    case leftBarButton
  }
}

extension BarButtonAble where Self: UIViewController {
  
  @discardableResult
  func makeBarButton(withCustomView view: UIView, position: BarButtonPosition) -> UIBarButtonItem {
    let barButton = UIBarButtonItem(customView: view)
    return barButtonPosition(barButton: barButton, position: position)
  }
  
  @discardableResult
  func makeBarButton(withImage image: UIImage?, position: BarButtonPosition) -> UIBarButtonItem {
    let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
    return barButtonPosition(barButton: barButton, position: position)
  }
  
  @discardableResult
  func makeBarButton(withTitle title: String, position: BarButtonPosition) -> UIBarButtonItem {
    let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
    barButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
    barButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .highlighted)
    barButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .selected)
    return barButtonPosition(barButton: barButton, position: position)
  }
  
  func hidesBackButton() {
    self.navigationItem.setHidesBackButton(true, animated: false )
  }
  
  private func barButtonPosition(barButton: UIBarButtonItem,  position: BarButtonPosition) -> UIBarButtonItem  {
    switch position {
    case .rightBarButton:
      self.navigationItem.setRightBarButton(barButton, animated: false)
      
    case .leftBarButton:
      self.navigationItem.setLeftBarButton(barButton, animated: false)
    }
    return barButton
  }
}
