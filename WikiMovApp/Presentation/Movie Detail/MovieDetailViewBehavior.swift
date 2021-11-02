// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

protocol MovieDetailViewBehavior: MovieViewBehavior, Hapticable {
  func configureView(with viewModel: MovieViewModel)
  func fireHapticFeedBack()
}
