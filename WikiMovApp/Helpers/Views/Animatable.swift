// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

protocol Animatable {}
extension Animatable where Self: UIViewController {
  func animate(with view: UIView, options: UIView.AnimationOptions = .transitionCrossDissolve, performAnimation: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
    UIView.transition(with: view, duration: 0.5, options: options, animations: {
      performAnimation()
    }, completion: completion)
  }
}
