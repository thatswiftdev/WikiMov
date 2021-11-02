// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

protocol MovieListViewBehavior: BarButtonAble, Animatable, MovieViewInput, MovieViewBehavior {
  func configureEmptyView(_ message: String)
}
