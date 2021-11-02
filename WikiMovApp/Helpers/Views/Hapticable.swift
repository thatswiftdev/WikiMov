// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

protocol Hapticable {}

extension Hapticable where Self: UIViewController {
  
  func impactGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.prepare()
    generator.impactOccurred()
  }
}
