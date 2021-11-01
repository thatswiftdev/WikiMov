// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

protocol MovieViewInput {
  var navigation: UINavigationController? { get }
}

protocol MovieListViewBehavior: BarButtonAble, Animatable, MovieViewInput {
  func show(isLoading: Bool)
}
